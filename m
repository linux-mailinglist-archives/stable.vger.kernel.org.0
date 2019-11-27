Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57D110B9FF
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfK0U66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731348AbfK0U66 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:58:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C69DC20678;
        Wed, 27 Nov 2019 20:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888337;
        bh=ItMXgs/Q9kt+48rsthlnVhaH6dBjICpKcSlbQsKI+IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XDkRLcI0DEgfPG3rkpoEVm4H8DFoVQ0lRrRDb1v6vMrwsTdn4JpEO3+xBA01DuUdc
         oly70ywgF0iKGIGnMPLzVQNpt0VJsZKodWKB8Fa3xN8pyJlGUasp1cM2TdYAg54Nnm
         M6+tOjsBhsiQRhuortZCWY3tVauS5fEcuLKCgUX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Klocke <philipp97kl@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/306] ALSA: i2c/cs8427: Fix int to char conversion
Date:   Wed, 27 Nov 2019 21:29:03 +0100
Message-Id: <20191127203121.701840129@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Klocke <philipp97kl@gmail.com>

[ Upstream commit eb7ebfa3c1989aa8e59d5e68ab3cddd7df1bfb27 ]

Compiling with clang yields the following warning:

sound/i2c/cs8427.c:140:31: warning: implicit conversion from 'int'
to 'char' changes value from 160 to -96 [-Wconstant-conversion]
    data[0] = CS8427_REG_AUTOINC | CS8427_REG_CORU_DATABUF;
            ~ ~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~

Because CS8427_REG_AUTOINC is defined as 128, it is too big for a
char field.
So change data from char to unsigned char, that it can hold the value.

This patch does not change the generated code.

Signed-off-by: Philipp Klocke <philipp97kl@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/i2c/cs8427.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index 2647309bc6757..8afa2f8884660 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -118,7 +118,7 @@ static int snd_cs8427_send_corudata(struct snd_i2c_device *device,
 	struct cs8427 *chip = device->private_data;
 	char *hw_data = udata ?
 		chip->playback.hw_udata : chip->playback.hw_status;
-	char data[32];
+	unsigned char data[32];
 	int err, idx;
 
 	if (!memcmp(hw_data, ndata, count))
-- 
2.20.1



