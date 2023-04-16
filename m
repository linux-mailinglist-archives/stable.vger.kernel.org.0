Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631256E3604
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 10:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjDPIO1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 04:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjDPIO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 04:14:26 -0400
X-Greylist: delayed 420 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 16 Apr 2023 01:14:23 PDT
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B3BF1FCC;
        Sun, 16 Apr 2023 01:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id:MIME-Version:Content-Transfer-Encoding; bh=1q0y+uK+PK
        am5wXdZTymKic3XyLnYvqjw4Kuxn+7cVk=; b=RM9rjXyw/dQrij7m5AdIGiUSG2
        0R7lHoKnhi7qpGvhecNJMQ6sV0dFVrfB/k3y99E9pQTCxw4Uuhjutn3Emkr5j/dn
        I3mWX09ZyqqpQGw0NPh95r3+q2meEEW87bDhDROSLzp5rc9sH6yCP2LDWgcj2ZVA
        Cqx9oKmbc0/b+vMhQ=
Received: from localhost.localdomain (unknown [10.7.101.92])
        by front01 (Coremail) with SMTP id 5oFpogA3pDxRrjtk2hfIDg--.8669S2;
        Sun, 16 Apr 2023 16:14:11 +0800 (CST)
From:   Ruihan Li <lrh2000@pku.edu.cn>
To:     linux-bluetooth@vger.kernel.org
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Ruihan Li <lrh2000@pku.edu.cn>, stable@vger.kernel.org
Subject: [PATCH] bluetooth: Perform careful capability checks in hci_sock_ioctl()
Date:   Sun, 16 Apr 2023 16:14:04 +0800
Message-Id: <20230416081404.8227-1-lrh2000@pku.edu.cn>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: 5oFpogA3pDxRrjtk2hfIDg--.8669S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww18ury8WFy5Kw4UGFWktFb_yoW8CF1kpF
        ZakFn8trWkJF1IvwnrJa1fJFWUAa4vgrW7GFZrC3y5AwsxCa10g3yFkryUKanrArsrAF4S
        vF129ryxKr1DJ37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6c
        xK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbV
        WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AF
        wI0_JF0_Jw1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Kr
        1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
        jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
        x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
        8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
        0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUO0PfDUUUU
X-CM-SenderInfo: yssqiiarrvmko6sn3hxhgxhubq/1tbiAgEBBVPy77oXEgAKs8
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Previously, capability was checked using capable(), which verified that the
caller of the ioctl system call had the required capability. In addition,
the result of the check would be stored in the HCI_SOCK_TRUSTED flag,
making it persistent for the socket.

However, malicious programs can abuse this approach by deliberately sharing
an HCI socket with a privileged task. The HCI socket will be marked as
trusted when the privileged task occasionally makes an ioctl call.

This problem can be solved by using sk_capable() to check capability, which
ensures that not only the current task but also the socket opener has the
specified capability, thus reducing the risk of privilege escalation
through the previously identified vulnerability.

Cc: stable@vger.kernel.org
Fixes: f81f5b2db869 ("Bluetooth: Send control open and close messages for HCI raw sockets")
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
---
 net/bluetooth/hci_sock.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 065812232..f597fe0db 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1003,7 +1003,14 @@ static int hci_sock_ioctl(struct socket *sock, unsigned int cmd,
 	if (hci_sock_gen_cookie(sk)) {
 		struct sk_buff *skb;
 
-		if (capable(CAP_NET_ADMIN))
+		/* Perform careful checks before setting the HCI_SOCK_TRUSTED
+		 * flag. Make sure that not only the current task but also
+		 * the socket opener has the required capability, since
+		 * privileged programs can be tricked into making ioctl calls
+		 * on HCI sockets, and the socket should not be marked as
+		 * trusted simply because the ioctl caller is privileged.
+		 */
+		if (sk_capable(sk, CAP_NET_ADMIN))
 			hci_sock_set_flag(sk, HCI_SOCK_TRUSTED);
 
 		/* Send event to monitor */
-- 
2.40.0

