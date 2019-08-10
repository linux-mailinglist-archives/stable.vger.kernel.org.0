Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60DD288DB5
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfHJUsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54850 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726800AbfHJUoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053W-KH; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003j2-3v; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yunfang Tai" <yunfangtai@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Lidong Chen" <lidongchen@tencent.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "=?UTF-8?q?haibinzhang=28=E5=BC=A0=E6=B5=B7=E6=96=8C=29?=" 
        <haibinzhang@tencent.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.318549544@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 129/157] vhost-net: set packet weight of tx polling
 to 2 * vq size
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: haibinzhang(张海斌)
 <haibinzhang@tencent.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/net.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -39,6 +39,10 @@ MODULE_PARM_DESC(experimental_zcopytx, "
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_NET_WEIGHT 0x80000
 
+/* Max number of packets transferred before requeueing the job.
+ * Using this limit prevents one virtqueue from starving rx. */
+#define VHOST_NET_PKT_WEIGHT(vq) ((vq)->num * 2)
+
 /* MAX number of TX used buffers for outstanding zerocopy */
 #define VHOST_MAX_PEND 128
 #define VHOST_GOODCOPY_LEN 256
@@ -351,6 +355,7 @@ static void handle_tx(struct vhost_net *
 	struct socket *sock;
 	struct vhost_net_ubuf_ref *uninitialized_var(ubufs);
 	bool zcopy, zcopy_used;
+	int sent_pkts = 0;
 
 	mutex_lock(&vq->mutex);
 	sock = vq->private_data;
@@ -450,7 +455,8 @@ static void handle_tx(struct vhost_net *
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
 		vhost_net_tx_packet(net);
-		if (unlikely(total_len >= VHOST_NET_WEIGHT)) {
+		if (unlikely(total_len >= VHOST_NET_WEIGHT) ||
+		    unlikely(++sent_pkts >= VHOST_NET_PKT_WEIGHT(vq))) {
 			vhost_poll_queue(&vq->poll);
 			break;
 		}

