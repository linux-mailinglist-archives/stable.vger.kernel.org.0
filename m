Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A004A620E
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 18:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiBAROy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 12:14:54 -0500
Received: from nef2.ens.fr ([129.199.96.40]:35188 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240473AbiBAROx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Feb 2022 12:14:53 -0500
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643735692; bh=TyY1aAcOn2EBkWnVqggE3slPb1bDTA+PMAxCC4JxA7M=;
        h=From:To:Cc:Subject:Date:From;
        b=ehs5oH7QImP4vIdoydsJ4d022Xa+PiSsDyG1qV+wXMO9o+EIykl7Qf0GOqzWYv/we
         VI40RRKkbWch9IUDsFwnhk2AYNn//2dRJVqVEdLh7/aAx1C5vhMu+Hy0TMfL8OJ4sh
         SfJlAqpqzwfgkln2uUAVNC2QEITX6K2BmmBGnjAg=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 211HEpVn013630
          ; Tue, 1 Feb 2022 18:14:52 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 211HEkQC085726 ; Tue, 1 Feb 2022 18:14:51 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH stable 4.4] Revert "tc358743: fix register i2c_rd/wr function fix"
Date:   Tue,  1 Feb 2022 18:14:41 +0100
Message-Id: <1643735681-14816-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 01 Feb 2022 18:14:52 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit a3f9c74652c749486bf9e989caabcae6f68272ee.

The reverted commit was backported and applied twice on the stable branch:
- First as commit 44f3c2b6e5e9 ("tc358743: fix register i2c_rd/wr
  function fix") at the right position `i2c_wr8_and_or`
- Then as commit a3f9c74652c7 ("tc358743: fix register i2c_rd/wr
  function fix") on the wrong function `i2c_wr16_and_or`

Fixes: a3f9c74652c7 ("tc358743: fix register i2c_rd/wr function fix")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 drivers/media/i2c/tc358743.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 546cd99..c3befb3 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -241,7 +241,7 @@ static void i2c_wr16(struct v4l2_subdev *sd, u16 reg, u16 val)

 static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
 {
-	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 1) & mask) | val, 1);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
 }

 static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)
--
2.7.4

