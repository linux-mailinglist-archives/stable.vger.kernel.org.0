Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA0134CA91
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbhC2IjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234893AbhC2Ihc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4160261601;
        Mon, 29 Mar 2021 08:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007026;
        bh=tTS/830+YCGd0xZ8eKOjdDSfRVCl5QjYOpbwfRfYudU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z3YZeg3cH4fq/c40qQ2df2lOjLDnHjyeI7JEw/Ot0SIBcSnJIYB2b61zLQs0eV1Xz
         eOpPTeUiGO23ssE3F63ZyDl3aIbdSX+mUgdBm65BXcHiIJ7pKm9wmcG4l+LJ92X1IV
         hhD0bCAPCFh//nrS3SG42X4LNzIl3kxvGo9fUeJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 192/254] platform/x86: dell-wmi-sysman: Fix release_attributes_data() getting called twice on init_bios_attributes() failure
Date:   Mon, 29 Mar 2021 09:58:28 +0200
Message-Id: <20210329075639.423882228@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 59bbbeb9c22cc7c55965cd5ea8c16af7f16e61eb ]

All calls of init_bios_attributes() will result in a
goto fail_create_group if they fail, which calls
release_attributes_data().

So there is no need to call release_attributes_data() from
init_bios_attributes() on failure itself.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index 8b251b2c37a2..58dc4571f987 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -491,7 +491,6 @@ nextobj:
 
 err_attr_init:
 	mutex_unlock(&wmi_priv.mutex);
-	release_attributes_data();
 	kfree(obj);
 	return retval;
 }
-- 
2.30.1



