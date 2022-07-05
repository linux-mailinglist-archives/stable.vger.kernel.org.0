Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0FE566D9B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiGEM0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbiGEMZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965221B7A7;
        Tue,  5 Jul 2022 05:17:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DA71B817D3;
        Tue,  5 Jul 2022 12:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B271C341C7;
        Tue,  5 Jul 2022 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023450;
        bh=qIRVdD+NVFVBnOkoHPP2no1csPZD28pEKNW3zlKXfHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5+u/f7kWlWD7n6h/LJLImvl6ds3FLl4fWUbWsznijaQJOfjbVrCGp6TNh9XAfkcq
         2fWkatmkyfDeLRd8B1tLbdmPGE3Ip0XwvT6Ca3Giiii0HozTHTYk96Kea/fIghvUaH
         k4X8C1dnViaA5ikavEia4jTm7cIkOfZrD2CKN+ko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>
Subject: [PATCH 5.18 064/102] platform/x86: thinkpad_acpi: Fix a memory leak of EFCH MMIO resource
Date:   Tue,  5 Jul 2022 13:58:30 +0200
Message-Id: <20220705115620.223049942@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

commit d2f33f0c3ad7b0d5262d9b986f1353265fad7a08 upstream.

Unlike release_mem_region(), a call to release_resource() does not
free the resource, so it has to be freed explicitly to avoid a memory
leak.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Fixes: 455cd867b85b ("platform/x86: thinkpad_acpi: Add a s2idle resume quirk for a number of laptops")
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220621155511.5b266395@endymion.delvare
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e6cb4a14cdd4..aa6ffeaa3932 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4529,6 +4529,7 @@ static void thinkpad_acpi_amd_s2idle_restore(void)
 	iounmap(addr);
 cleanup_resource:
 	release_resource(res);
+	kfree(res);
 }
 
 static struct acpi_s2idle_dev_ops thinkpad_acpi_s2idle_dev_ops = {
-- 
2.37.0



