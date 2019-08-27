Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0C949F696
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 01:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbfH0XKW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 27 Aug 2019 19:10:22 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:58935 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfH0XKW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 19:10:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126] helo=xylophone.i.decadent.org.uk)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1i2kbS-0000he-Ly; Wed, 28 Aug 2019 00:10:18 +0100
Date:   Wed, 28 Aug 2019 00:10:17 +0100
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable <stable@vger.kernel.org>
Subject: [PATCH 4.4 03/13] vhost-net: set packet weight of tx polling to 2 *
 vq size
Message-ID: <20190827231017.GC11046@xylophone.i.decadent.org.uk>
References: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190827230906.GA11046@xylophone.i.decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: haibinzhang(张海斌) <haibinzhang@tencent.com>

commit a2ac99905f1ea8b15997a6ec39af69aa28a3653b upstream.

handle_tx will delay rx for tens or even hundreds of milliseconds when tx busy
polling udp packets with small length(e.g. 1byte udp payload), because setting
VHOST_NET_WEIGHT takes into account only sent-bytes but no single packet length.

Ping-Latencies shown below were tested between two Virtual Machines using
netperf (UDP_STREAM, len=1), and then another machine pinged the client:

vq size=256
Packet-Weight   Ping-Latencies(millisecond)
                   min      avg       max
Origin           3.319   18.489    57.303
64               1.643    2.021     2.552
128              1.825    2.600     3.224
256              1.997    2.710     4.295
512              1.860    3.171     4.631
1024             2.002    4.173     9.056
2048             2.257    5.650     9.688
4096             2.093    8.508    15.943

vq size=512
Packet-Weight   Ping-Latencies(millisecond)
                   min      avg       max
Origin           6.537   29.177    66.245
64               2.798    3.614     4.403
128              2.861    3.820     4.775
256              3.008    4.018     4.807
512              3.254    4.523     5.824
1024             3.079    5.335     7.747
2048             3.944    8.201    12.762
4096             4.158   11.057    19.985

Seems pretty consistent, a small dip at 2 VQ sizes.
Ring size is a hint from device about a burst size it can tolerate. Based on
benchmarks, set the weight to 2 * vq size.

To evaluate this change, another tests were done using netperf(RR, TX) between
two machines with Intel(R) Xeon(R) Gold 6133 CPU @ 2.50GHz, and vq size was
tweaked through qemu. Results shown below does not show obvious changes.

vq size=256 TCP_RR                vq size=512 TCP_RR
size/sessions/+thu%/+normalize%   size/sessions/+thu%/+normalize%
   1/       1/  -7%/        -2%      1/       1/   0%/        -2%
   1/       4/  +1%/         0%      1/       4/  +1%/         0%
   1/       8/  +1%/        -2%      1/       8/   0%/        +1%
  64/       1/  -6%/         0%     64/       1/  +7%/        +3%
  64/       4/   0%/        +2%     64/       4/  -1%/        +1%
  64/       8/   0%/         0%     64/       8/  -1%/        -2%
 256/       1/  -3%/        -4%    256/       1/  -4%/        -2%
 256/       4/  +3%/        +4%    256/       4/  +1%/        +2%
 256/       8/  +2%/         0%    256/       8/  +1%/        -1%

vq size=256 UDP_RR                vq size=512 UDP_RR
size/sessions/+thu%/+normalize%   size/sessions/+thu%/+normalize%
   1/       1/  -5%/        +1%      1/       1/  -3%/        -2%
   1/       4/  +4%/        +1%      1/       4/  -2%/        +2%
   1/       8/  -1%/        -1%      1/       8/  -1%/         0%
  64/       1/  -2%/        -3%     64/       1/  +1%/        +1%
  64/       4/  -5%/        -1%     64/       4/  +2%/         0%
  64/       8/   0%/        -1%     64/       8/  -2%/        +1%
 256/       1/  +7%/        +1%    256/       1/  -7%/         0%
 256/       4/  +1%/        +1%    256/       4/  -3%/        -4%
 256/       8/  +2%/        +2%    256/       8/  +1%/        +1%

vq size=256 TCP_STREAM            vq size=512 TCP_STREAM
size/sessions/+thu%/+normalize%   size/sessions/+thu%/+normalize%
  64/       1/   0%/        -3%     64/       1/   0%/         0%
  64/       4/  +3%/        -1%     64/       4/  -2%/        +4%
  64/       8/  +9%/        -4%     64/       8/  -1%/        +2%
 256/       1/  +1%/        -4%    256/       1/  +1%/        +1%
 256/       4/  -1%/        -1%    256/       4/  -3%/         0%
 256/       8/  +7%/        +5%    256/       8/  -3%/         0%
 512/       1/  +1%/         0%    512/       1/  -1%/        -1%
 512/       4/  +1%/        -1%    512/       4/   0%/         0%
 512/       8/  +7%/        -5%    512/       8/  +6%/        -1%
1024/       1/   0%/        -1%   1024/       1/   0%/        +1%
1024/       4/  +3%/         0%   1024/       4/  +1%/         0%
1024/       8/  +8%/        +5%   1024/       8/  -1%/         0%
2048/       1/  +2%/        +2%   2048/       1/  -1%/         0%
2048/       4/  +1%/         0%   2048/       4/   0%/        -1%
2048/       8/  -2%/         0%   2048/       8/   5%/        -1%
4096/       1/  -2%/         0%   4096/       1/  -2%/         0%
4096/       4/  +2%/         0%   4096/       4/   0%/         0%
4096/       8/  +9%/        -2%   4096/       8/  -5%/        -1%

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Haibin Zhang <haibinzhang@tencent.com>
Signed-off-by: Yunfang Tai <yunfangtai@tencent.com>
Signed-off-by: Lidong Chen <lidongchen@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
---
 drivers/vhost/net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f46317135224..b8496f713bc6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -39,6 +39,10 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_NET_WEIGHT 0x80000
 
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving rx. */
+#define VHOST_NET_PKT_WEIGHT(vq) ((vq)->num * 2)
+
 /* MAX number of TX used buffers for outstanding zerocopy */
 #define VHOST_MAX_PEND 128
 #define VHOST_GOODCOPY_LEN 256
@@ -308,6 +312,7 @@ static void handle_tx(struct vhost_net *net)
 	struct socket *sock;
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
 	bool zcopy, zcopy_used;
+	int sent_pkts = 0;
 
 	mutex_lock(&vq->mutex);
 	sock = vq->private_data;
@@ -408,7 +413,8 @@ static void handle_tx(struct vhost_net *net)
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
+		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
+		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT(vq))) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}
-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom


