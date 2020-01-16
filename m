Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B3913FFD7
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390786AbgAPXVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390780AbgAPXVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50C442073A;
        Thu, 16 Jan 2020 23:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216867;
        bh=WXsHBzZ5UAA2RNJv8dslmJNwg5nER0+WsBMNlfLOcgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ch1+UfSVesiGzd6XneQbhyWgn6QKZv9pzD/HjmH2MZWZQInEtrM2vlHQm9wqr7ILi
         fP5lCEqC/xeMbuTUdKGMslXZ3VK2E2rQlot74JOAQBe55vvlrHFkTeBWOoaf8DMPkP
         eJs1O6SW56R6BvAvXk6Fc98vsJ3JHOBoo4IPUboI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 036/203] s390/qeth: vnicc Fix init to default
Date:   Fri, 17 Jan 2020 00:15:53 +0100
Message-Id: <20200116231747.287882624@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

commit d1b9ae1864fc3c000e0eb4af8482d78c63e0915a upstream.

During vnicc_init wanted_char should be compared to cur_char and not
to QETH_VNICC_DEFAULT. Without this patch there is no way to enforce
the default values as desired values.

Note, that it is expected, that a card comes online with default values.
This patch was tested with private card firmware.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/net/qeth_l2_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2070,7 +2070,9 @@ static void qeth_l2_vnicc_init(struct qe
 	/* enforce assumed default values and recover settings, if changed  */
 	error |= qeth_l2_vnicc_recover_timeout(card, QETH_VNICC_LEARNING,
 					       timeout);
-	chars_tmp = card->options.vnicc.wanted_chars ^ QETH_VNICC_DEFAULT;
+	/* Change chars, if necessary  */
+	chars_tmp = card->options.vnicc.wanted_chars ^
+		    card->options.vnicc.cur_chars;
 	chars_len = sizeof(card->options.vnicc.wanted_chars) * BITS_PER_BYTE;
 	for_each_set_bit(i, &chars_tmp, chars_len) {
 		vnicc = BIT(i);


