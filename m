Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E799F528248
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 12:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242677AbiEPKjc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 16 May 2022 06:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiEPKjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 06:39:31 -0400
X-Greylist: delayed 955 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 03:39:30 PDT
Received: from sender4-of-o58.zoho.com (sender4-of-o58.zoho.com [136.143.188.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7848D237F4
        for <stable@vger.kernel.org>; Mon, 16 May 2022 03:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1652696606; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Kx1bU6cM2rTQ45627TLaIrUmyuK8JKxe+6dp969h79UtC72vzaptU0KAgj+yR01SB944vwrFBEOUrv5e3GeHDr5wpbNgqKKhX+Ec69AwAwBKYdQyIPWyBF003aykHC/weZGvfvuwbuwCpe45CS/kCgfMkHkZBc6wewNUhlUJ77k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1652696606; h=Content-Type:Content-Transfer-Encoding:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=aKy/2D1I+Ijo3H2U2qrIhNvqL3xXRiti3x//u1F3D3k=; 
        b=eMhvNN6dhsImM1RDhgTfGczy4vtJCZgj5bQU8XN4ByPWOLVnroLJcfCcBXmFtQArvlItw5JXc15lPafwdUDB4dg4nztF4oEnpl+gC+VXWIK87IsXiAr+IXCCxQ/Y3StZhnoDckF2WHZfB3vR8LW+LuBgYe5rZ+R5p3itFGvitJ0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        spf=pass  smtp.mailfrom=linux@mniewoehner.de;
        dmarc=pass header.from=<linux@mniewoehner.de>
Received: from z3r0.lan (185.31.62.161 [185.31.62.161]) by mx.zohomail.com
        with SMTPS id 1652696605359658.627437004699; Mon, 16 May 2022 03:23:25 -0700 (PDT)
Message-ID: <50eb664046b0d036a434c4a602087b791b6e796f.camel@mniewoehner.de>
Subject: [PATCH] platform/x86: intel-hid: fix _DSM function index handling
From:   Michael =?ISO-8859-1?Q?Niew=F6hner?= <linux@mniewoehner.de>
To:     Alex Hung <alex.hung@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date:   Mon, 16 May 2022 12:23:22 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.42.2 
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

intel_hid_dsm_fn_mask is a bit mask containing one bit for each function
index. Fix the function index check in intel_hid_evaluate_method
accordingly, which was missed in commit 97ab4516205e ("platform/x86:
intel-hid: fix _DSM function index handling").

Signed-off-by: Michael Niewöhner <linux@mniewoehner.de>
---
 drivers/platform/x86/intel/hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/hid.c b/drivers/platform/x86/intel/hid.c
index 13f8cf70b9ae..5c39d40a701b 100644
--- a/drivers/platform/x86/intel/hid.c
+++ b/drivers/platform/x86/intel/hid.c
@@ -238,7 +238,7 @@ static bool intel_hid_evaluate_method(acpi_handle handle,
 
        method_name = (char *)intel_hid_dsm_fn_to_method[fn_index];
 
-       if (!(intel_hid_dsm_fn_mask & fn_index))
+       if (!(intel_hid_dsm_fn_mask & BIT(fn_index)))
                goto skip_dsm_eval;
 
        obj = acpi_evaluate_dsm_typed(handle, &intel_dsm_guid,
-- 
2.34.1


