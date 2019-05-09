Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F9A19118
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfEISxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbfEISw7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77142217D6;
        Thu,  9 May 2019 18:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427979;
        bh=IDw46fZYrf8Ouu1BoNhchZFD0deoikTUfU2RsJt3vcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPPAs9n4Lu80ttjonFcqYLScaJsBh9HWwHw0sgvNG5GX8P0NWn9boSm6Rc7oL2jIo
         g8boIVA9r6E9Y+W8eMkhA7EIfFhc42kNdi+x+JiByB+ekGgnpCvybcUKN688yORJnI
         9MNpfuHrAUbTzYhGIDP7jlwJjA3Yx9z5fcqwNefA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        =?UTF-8?q?David=20M=C3=BCller?= <dave.mueller@gmx.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 69/95] platform/x86: pmc_atom: Drop __initconst on dmi table
Date:   Thu,  9 May 2019 20:42:26 +0200
Message-Id: <20190509181314.280484929@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b995dcca7cf12f208cfd95fd9d5768dca7cccec7 ]

It's used by probe and that isn't an init function. Drop this so that we
don't get a section mismatch.

Reported-by: kbuild test robot <lkp@intel.com>
Cc: David Müller <dave.mueller@gmx.ch>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Fixes: 7c2e07130090 ("clk: x86: Add system specific quirk to mark clocks as critical")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/pmc_atom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/pmc_atom.c b/drivers/platform/x86/pmc_atom.c
index eaec2d306481c..c7039f52ad518 100644
--- a/drivers/platform/x86/pmc_atom.c
+++ b/drivers/platform/x86/pmc_atom.c
@@ -396,7 +396,7 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc)
  * Some systems need one or more of their pmc_plt_clks to be
  * marked as critical.
  */
-static const struct dmi_system_id critclk_systems[] __initconst = {
+static const struct dmi_system_id critclk_systems[] = {
 	{
 		.ident = "MPL CEC1x",
 		.matches = {
-- 
2.20.1



