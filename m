Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589C11CAECF
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgEHMs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729669AbgEHMsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 581A12145D;
        Fri,  8 May 2020 12:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942103;
        bh=AAeV4GeEnJgXtRjAjYtvSoUzsCDgz5TClALxpSv5FcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h7XHrxYHPan1z06SifvcN8Xeqm3JXxwyjOTOLO6i/iA12mPdpfelBNw71DmFVzsP/
         ZfYOfIwwjp7wH+1a2PofBzyrevM+JBxF/Bch8Q0tf1Jck4/g2Rwp1PnO6sbUG26r5D
         cGwlEbSt4cfIxd5zTTIW7WMPL6LfPPdR57+pwzic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 4.4 298/312] regulator: Try to resolve regulators supplies on registration
Date:   Fri,  8 May 2020 14:34:49 +0200
Message-Id: <20200508123145.337797569@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javier@osg.samsung.com>

commit 5e3ca2b349b1e2c80b060b51bbf2af37448fad85 upstream.

Commit 6261b06de565 ("regulator: Defer lookup of supply to regulator_get")
moved the regulator supplies lookup logic from the regulators registration
to the regulators get time.

Unfortunately, that changed the behavior of the regulator core since now a
parent supply with a child regulator marked as always-on, won't be enabled
unless a client driver attempts to get the child regulator during boot.

This patch tries to resolve the parent supply for the already registered
regulators each time that a new regulator is registered. So the regulators
that have child regulators marked as always on will be enabled regardless
if a driver gets the child regulator or not.

That was the behavior before the mentioned commit, since parent supplies
were looked up at regulator registration time instead of during child get.

Since regulator_resolve_supply() checks for rdev->supply, most of the times
it will be a no-op. Errors aren't checked to keep the possible out of order
dependencies which was the motivation for the mentioned commit.

Also, the supply being available will be enforced on regulator get anyways
in case the resolve fails on regulators registration.

Fixes: 6261b06de565 ("regulator: Defer lookup of supply to regulator_get")
Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 4.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3822,6 +3822,11 @@ static void rdev_init_debugfs(struct reg
 			   &rdev->bypass_count);
 }
 
+static int regulator_register_resolve_supply(struct device *dev, void *data)
+{
+	return regulator_resolve_supply(dev_to_rdev(dev));
+}
+
 /**
  * regulator_register - register regulator
  * @regulator_desc: regulator to register
@@ -3968,6 +3973,10 @@ regulator_register(const struct regulato
 	}
 
 	rdev_init_debugfs(rdev);
+
+	/* try to resolve regulators supply since a new one was registered */
+	class_for_each_device(&regulator_class, NULL, NULL,
+			      regulator_register_resolve_supply);
 out:
 	mutex_unlock(&regulator_list_mutex);
 	kfree(config);


