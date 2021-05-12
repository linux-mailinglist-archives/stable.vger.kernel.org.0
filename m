Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABC837CCA4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244449AbhELQqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239438AbhELQjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 181CF61CE0;
        Wed, 12 May 2021 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835405;
        bh=lkYbGQTqd5kSKRn2IRubul+douMPlxBIaJa5rUxYCRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8ETj644NsEOuOSm/IRl5qHilaSdO0LvsKmn4H1WITCUlTvq5CtJ0yDzTfjzEfdMM
         Pk+y/Q27CcNiOhbcuTBdmY+K0GmYsCdudVA3SVbXbyign7pT86T5C1LwDk5wFdJfBn
         OC0Lvv4QleRikjSpcCg1h6bU6XXHrJMZZh1b21Bo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 330/677] platform/surface: aggregator: fix a bit test
Date:   Wed, 12 May 2021 16:46:16 +0200
Message-Id: <20210512144848.221221527@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 366f0a30c8a01e79255221539a52909cc4c7bd25 ]

The "funcs" variable is a u64.  If "func" is more than 31 then the
BIT() shift will wrap instead of testing the high bits.

Fixes: c167b9c7e3d6 ("platform/surface: Add Surface Aggregator subsystem")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Link: https://lore.kernel.org/r/YH6UUhJhGk3mk13b@mwanda
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/surface/aggregator/controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/surface/aggregator/controller.c b/drivers/platform/surface/aggregator/controller.c
index 5bcb59ed579d..89761d3e1a47 100644
--- a/drivers/platform/surface/aggregator/controller.c
+++ b/drivers/platform/surface/aggregator/controller.c
@@ -1040,7 +1040,7 @@ static int ssam_dsm_load_u32(acpi_handle handle, u64 funcs, u64 func, u32 *ret)
 	union acpi_object *obj;
 	u64 val;
 
-	if (!(funcs & BIT(func)))
+	if (!(funcs & BIT_ULL(func)))
 		return 0; /* Not supported, leave *ret at its default value */
 
 	obj = acpi_evaluate_dsm_typed(handle, &SSAM_SSH_DSM_GUID,
-- 
2.30.2



