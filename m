Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2D073EB1
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388845AbfGXTgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:36:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389131AbfGXTgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:36:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CA1214AF;
        Wed, 24 Jul 2019 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997005;
        bh=UxYvXnkdRDbNmoHxr3kNaNh8LHIa6c+iKXd+dyTranE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuJxCnlNO1Mc3HlImkA2KcWx5mWDRgfSkxqGMILkpf3mRcykDj5Hqw7R49WxR/SId
         J+oZ070sIa6dXtkTPC1BLdhLWntW1DnVuYJODaxg7bNhIGAMi1vKWjraz86zO80Y1O
         QAj2gDfq1QyBVQ9BdcnRkemBR/splZZKN7OMYV50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.2 289/413] Input: alps - fix a mismatch between a condition check and its comment
Date:   Wed, 24 Jul 2019 21:19:40 +0200
Message-Id: <20190724191756.923211294@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 771a081e44a9baa1991ef011cc453ef425591740 upstream.

In the function alps_is_cs19_trackpoint(), we check if the param[1] is
in the 0x20~0x2f range, but the code we wrote for this checking is not
correct:
(param[1] & 0x20) does not mean param[1] is in the range of 0x20~0x2f,
it also means the param[1] is in the range of 0x30~0x3f, 0x60~0x6f...

Now fix it with a new condition checking ((param[1] & 0xf0) == 0x20).

Fixes: 7e4935ccc323 ("Input: alps - don't handle ALPS cs19 trackpoint-only device")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2876,7 +2876,7 @@ static bool alps_is_cs19_trackpoint(stru
 	 * trackpoint-only devices have their variant_ids equal
 	 * TP_VARIANT_ALPS and their firmware_ids are in 0x20~0x2f range.
 	 */
-	return param[0] == TP_VARIANT_ALPS && (param[1] & 0x20);
+	return param[0] == TP_VARIANT_ALPS && ((param[1] & 0xf0) == 0x20);
 }
 
 static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)


