Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9D42C0B81
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgKWNZm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:44156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731143AbgKWMcz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:32:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18E382076E;
        Mon, 23 Nov 2020 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134774;
        bh=p/BMhVuLgfQmPSua40UMbAp85aa9kbc6tWNh85jGz6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/CajdNhScmR+8rdcqo6uKogWAmnR5gPxjLIU701NLY76gMIsdg3Ei9qcDLpq+DOH
         jNl5IxriqAkbfi88+TG5UlGLhVXFjG+CtFg/jdBGrTJLBNzS7rfndxeq2uP1TaiK+D
         KWVVlStsrFvJ7sqLhuQLa/bhVgM91peHYWeLK4Go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 78/91] regulator: pfuze100: limit pfuze-support-disable-sw to pfuze{100,200}
Date:   Mon, 23 Nov 2020 13:22:38 +0100
Message-Id: <20201123121813.119234370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

commit 365ec8b61689bd64d6a61e129e0319bf71336407 upstream.

Limit the fsl,pfuze-support-disable-sw to the pfuze100 and pfuze200
variants.
When enabling fsl,pfuze-support-disable-sw and using a pfuze3000 or
pfuze3001, the driver would choose pfuze100_sw_disable_regulator_ops
instead of the newly introduced and correct pfuze3000_sw_regulator_ops.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Fixes: 6f1cf5257acc ("regualtor: pfuze100: correct sw1a/sw2 on pfuze3000")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201110174113.2066534-1-sean@geanix.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/pfuze100-regulator.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -755,11 +755,14 @@ static int pfuze100_regulator_probe(stru
 		 * the switched regulator till yet.
 		 */
 		if (pfuze_chip->flags & PFUZE_FLAG_DISABLE_SW) {
-			if (pfuze_chip->regulator_descs[i].sw_reg) {
-				desc->ops = &pfuze100_sw_disable_regulator_ops;
-				desc->enable_val = 0x8;
-				desc->disable_val = 0x0;
-				desc->enable_time = 500;
+			if (pfuze_chip->chip_id == PFUZE100 ||
+				pfuze_chip->chip_id == PFUZE200) {
+				if (pfuze_chip->regulator_descs[i].sw_reg) {
+					desc->ops = &pfuze100_sw_disable_regulator_ops;
+					desc->enable_val = 0x8;
+					desc->disable_val = 0x0;
+					desc->enable_time = 500;
+				}
 			}
 		}
 


