Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C27B146247
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 08:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725828AbgAWHJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 02:09:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgAWHJ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 02:09:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0184C24655;
        Thu, 23 Jan 2020 07:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579763367;
        bh=kBAtxI0TgTRxS9S5BSjVVWHWG6kzJ8ucZYvMuQ7UBhM=;
        h=Subject:To:From:Date:From;
        b=rCTueUt4DxZNq24BYIAeewJSuoy4/879vsJf7AilIlTjOXtyAQ8/3rEW3JPfhzglh
         60vQC+qWHm3SvAYwM2HNkpwJXl3y/I3YnYaohLtVH9dulQ2qwyH7oE9o+vRuEBLRqo
         Lhxfhrm2ehCdjYheHGHvUkH5psaeTWKKi5NmnzkU=
Subject: patch "staging: most: net: fix buffer overflow" added to staging-next
To:     andrey.shvetsov@k2l.de, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 Jan 2020 08:09:12 +0100
Message-ID: <157976335227199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: most: net: fix buffer overflow

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 4d1356ac12f4d5180d0df345d85ff0ee42b89c72 Mon Sep 17 00:00:00 2001
From: Andrey Shvetsov <andrey.shvetsov@k2l.de>
Date: Thu, 16 Jan 2020 18:22:39 +0100
Subject: staging: most: net: fix buffer overflow

If the length of the socket buffer is 0xFFFFFFFF (max size for an
unsigned int), then payload_len becomes 0xFFFFFFF1 after subtracting 14
(ETH_HLEN).  Then, mdp_len is set to payload_len + 16 (MDP_HDR_LEN)
which overflows and results in a value of 2.  These values for
payload_len and mdp_len will pass current buffer size checks.

This patch checks if derived from skb->len sum may overflow.

The check is based on the following idea:

For any `unsigned V1, V2` and derived `unsigned SUM = V1 + V2`,
`V1 + V2` overflows iif `SUM < V1`.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrey Shvetsov <andrey.shvetsov@k2l.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200116172238.6046-1-andrey.shvetsov@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/most/net/net.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/staging/most/net/net.c b/drivers/staging/most/net/net.c
index 8218c9a06cb5..5547e36e09de 100644
--- a/drivers/staging/most/net/net.c
+++ b/drivers/staging/most/net/net.c
@@ -82,6 +82,11 @@ static int skb_to_mamac(const struct sk_buff *skb, struct mbo *mbo)
 	unsigned int payload_len = skb->len - ETH_HLEN;
 	unsigned int mdp_len = payload_len + MDP_HDR_LEN;
 
+	if (mdp_len < skb->len) {
+		pr_err("drop: too large packet! (%u)\n", skb->len);
+		return -EINVAL;
+	}
+
 	if (mbo->buffer_length < mdp_len) {
 		pr_err("drop: too small buffer! (%d for %d)\n",
 		       mbo->buffer_length, mdp_len);
@@ -129,6 +134,11 @@ static int skb_to_mep(const struct sk_buff *skb, struct mbo *mbo)
 	u8 *buff = mbo->virt_address;
 	unsigned int mep_len = skb->len + MEP_HDR_LEN;
 
+	if (mep_len < skb->len) {
+		pr_err("drop: too large packet! (%u)\n", skb->len);
+		return -EINVAL;
+	}
+
 	if (mbo->buffer_length < mep_len) {
 		pr_err("drop: too small buffer! (%d for %d)\n",
 		       mbo->buffer_length, mep_len);
-- 
2.25.0


