Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D74401013C8
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfKSF1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:45536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbfKSF1R (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6730C222DC;
        Tue, 19 Nov 2019 05:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141236;
        bh=z42NMZtRegQyAv3PPGmyHQ/taWk4UXkfZVgfVcUHReg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1gXEQXTse9GG4IABhaSv7hxCctrk/FtDCqoPSrmiBMNuse4AL1FNhLaWilRyROrW9
         yAeWfay2eTfJ1NeAdfwK7xuTrrcy2+6OLxYNJ8nvR9lViOv0wc5kC3HukbVgqZnIEM
         +uiGbVnrS9nyfA8m3Gq1t/z4IJeje+l9wGyzNC6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/422] media: vicodec: fix out-of-range values when decoding
Date:   Tue, 19 Nov 2019 06:14:48 +0100
Message-Id: <20191119051405.266973350@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit be5a1509af8dd8a78fea24a35fe4a82d4cd0ae70 ]

While decoding you need to make sure you do not get values < 0
or > 255. Note that since this code will also be used in userspace
utilities the clamp macro isn't used since that is kernel-only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-codec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index 2d047646f6147..d854b2344f12b 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -588,8 +588,14 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
 	int i, j;
 
 	for (i = 0; i < 8; i++) {
-		for (j = 0; j < 8; j++)
-			*dst++ = *input++;
+		for (j = 0; j < 8; j++, input++, dst++) {
+			if (*input < 0)
+				*dst = 0;
+			else if (*input > 255)
+				*dst = 255;
+			else
+				*dst = *input;
+		}
 		dst += stride - 8;
 	}
 }
-- 
2.20.1



