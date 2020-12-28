Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC372E3ECB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504703AbgL1Occ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:32:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504706AbgL1Ocb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACEA322BEA;
        Mon, 28 Dec 2020 14:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165936;
        bh=v0iFqxSzFZ1hMPakMM1V68IL+iaKKBi0HfkVvQCwLcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Yq11nw0JUe0kqoW4f/67JMxG5ddFDX/bZKHHT3uEP6mgbVM3oVtVJp+LGGo7Fbdi
         uxxxUNkkiIwaMjq0eqDh03a1dnD9DguvuXORdSjTSTHFB+7FPg21Z3+dDRYx/wVNyH
         W5qH7GDvHj9H7yG5kVib1zGg/+LprlCjjrFauHpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Garnacho <carlosg@gnome.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 706/717] platform/x86: intel-vbtn: Allow switch events on Acer Switch Alpha 12
Date:   Mon, 28 Dec 2020 13:51:44 +0100
Message-Id: <20201228125054.813845394@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Garnacho <carlosg@gnome.org>

commit fe6000990394639ed374cb76c313be3640714f47 upstream.

This 2-in-1 model (Product name: Switch SA5-271) features a SW_TABLET_MODE
that works as it would be expected, both when detaching the keyboard and
when folding it behind the tablet body.

It used to work until the introduction of the allow list at
commit 8169bd3e6e193 ("platform/x86: intel-vbtn: Switch to an allow-list
for SW_TABLET_MODE reporting"). Add this model to it, so that the Virtual
Buttons device announces the EV_SW features again.

Fixes: 8169bd3e6e193 ("platform/x86: intel-vbtn: Switch to an allow-list for SW_TABLET_MODE reporting")
Cc: stable@vger.kernel.org
Signed-off-by: Carlos Garnacho <carlosg@gnome.org>
Link: https://lore.kernel.org/r/20201201135727.212917-1-carlosg@gnome.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/intel-vbtn.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -216,6 +216,12 @@ static const struct dmi_system_id dmi_sw
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion 13 x360 PC"),
 		},
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Switch SA5-271"),
+		},
+	},
 	{} /* Array terminator */
 };
 


