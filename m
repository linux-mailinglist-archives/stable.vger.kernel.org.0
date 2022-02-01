Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6984A6382
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiBASRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51254 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiBASRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12D81CE1A60;
        Tue,  1 Feb 2022 18:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73B3C340EC;
        Tue,  1 Feb 2022 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739466;
        bh=AA9nT8syglKZRiXJ5lBCfJnIMjmBI1S/PCXXXOgmq+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRQjUMa8KzUuk60p3TnDB2tw/n+wqeR3JDzORAeViKyc435B5tni9Te+izeWamhku
         jLeg6OseJ3UgX47D51rN6YalmAPYeRDIVnrlJyCPUlDZe+npRwO59zL8UlmZU8I3aK
         DzoGsO6IMw+Ty4GCpOjKTqDNF++qvAj+M2cBhvdI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Guillaume Bertholon" 
        <guillaume.bertholon@ens.fr>,
        Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: [PATCH 4.4 24/25] Revert "tc358743: fix register i2c_rd/wr function fix"
Date:   Tue,  1 Feb 2022 19:16:48 +0100
Message-Id: <20220201180822.940256585@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Bertholon <guillaume.bertholon@ens.fr>

This reverts commit a3f9c74652c749486bf9e989caabcae6f68272ee.

The reverted commit was backported and applied twice on the stable branch:
- First as commit 44f3c2b6e5e9 ("tc358743: fix register i2c_rd/wr
  function fix") at the right position `i2c_wr8_and_or`
- Then as commit a3f9c74652c7 ("tc358743: fix register i2c_rd/wr
  function fix") on the wrong function `i2c_wr16_and_or`

Fixes: a3f9c74652c7 ("tc358743: fix register i2c_rd/wr function fix")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/tc358743.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -241,7 +241,7 @@ static void i2c_wr16(struct v4l2_subdev
 
 static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
 {
-	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 1) & mask) | val, 1);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
 }
 
 static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)


