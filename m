Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7942ABAE8
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731747AbgKINXr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:23:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387913AbgKINUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:20:14 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E65020731;
        Mon,  9 Nov 2020 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604928013;
        bh=SomfTy7xvoRYWIRiKoLH7kzUnccZPZAoGzIEM11TDvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWbV2VaeWLAayczO/VGb4eDvVhZN9dgbzngCEHhihm75akGdDt6EFbnG7/arTutc4
         WE1ufxRAnzVJVA5lDVJv5ndyG9ZZB8cmnk5bNecjJxvd9fjpD5GCpGmXxDhMMzfZjx
         /rW6h3EJAkr6Zw4Cne0CHChEbNfG+F7EV251C+RY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.9 067/133] regulator: defer probe when trying to get voltage from unresolved supply
Date:   Mon,  9 Nov 2020 13:55:29 +0100
Message-Id: <20201109125033.957823889@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit cf1ad559a20d1930aa7b47a52f54e1f8718de301 upstream.

regulator_get_voltage_rdev() is called in regulator probe() when
applying machine constraints.  The "fixed" commit exposed the problem
that non-bypassed regulators can forward the request to its parent
(like bypassed ones) supply. Return -EPROBE_DEFER when the supply
is expected but not resolved yet.

Fixes: aea6cb99703e ("regulator: resolve supply after creating regulator")
Cc: stable@vger.kernel.org
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Reported-by: Ondřej Jirman <megous@megous.com>
Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Ondřej Jirman <megous@megous.com>
Link: https://lore.kernel.org/r/a9041d68b4d35e4a2dd71629c8a6422662acb5ee.1604351936.git.mirq-linux@rere.qmqm.pl
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4128,6 +4128,8 @@ int regulator_get_voltage_rdev(struct re
 		ret = rdev->desc->fixed_uV;
 	} else if (rdev->supply) {
 		ret = regulator_get_voltage_rdev(rdev->supply->rdev);
+	} else if (rdev->supply_name) {
+		return -EPROBE_DEFER;
 	} else {
 		return -EINVAL;
 	}


