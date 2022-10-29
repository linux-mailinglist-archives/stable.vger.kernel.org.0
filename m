Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90104612652
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 00:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiJ2W7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Oct 2022 18:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJ2W7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Oct 2022 18:59:39 -0400
X-Greylist: delayed 449 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 29 Oct 2022 15:59:33 PDT
Received: from mx1.heh.ee (heh.ee [213.35.143.160])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8A5C24
        for <stable@vger.kernel.org>; Sat, 29 Oct 2022 15:59:32 -0700 (PDT)
Received: from [0.0.0.0] (unknown [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mx1.heh.ee (Hehee) with ESMTPSA id 7CA6D17048C;
        Sun, 30 Oct 2022 01:52:00 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ristioja.ee; s=mail;
        t=1667083920; bh=fuqLyQU+4l1RBP7RN3fqmf15KL4n1Lzc+AUa0j4/jXU=;
        h=Date:From:Subject:To:Cc;
        b=DyqoMDWB7abjoOEekS/LNWGltJpfHOtku1aT4l7rf8HkMYnkxoqMX8r9ezsOWRFRx
         iDlx4EL+ieDaUGVDJ1pwnDZrQXAugVPDwjfCyr80HC0jQMMzV1jXD6Zppio/IVV3Pg
         dfJByJrFkeSL5v6rG64fRNfInw2qCeRRWwWWYrn8=
Message-ID: <d166779c-a845-2483-41c6-4cd7e06c22c3@ristioja.ee>
Date:   Sun, 30 Oct 2022 01:51:59 +0300
MIME-Version: 1.0
User-Agent: undefined
From:   Jaak Ristioja <jaak@ristioja.ee>
Subject: drivers/platform/x86/amd/pmc.c compile error in 6.0.6
To:     stable@vger.kernel.org
Content-Language: et-EE, en-US
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

The following error popped up when compiling Linux kernel version 6.0.6:

drivers/platform/x86/amd/pmc.c: In function 'amd_pmc_verify_czn_rtc':
drivers/platform/x86/amd/pmc.c:640:22: error: implicit declaration of 
function 'amd_pmc_get_smu_version' [-Werror=implicit-function-declaration]
   640 |                 rc = amd_pmc_get_smu_version(pdev);
       |                      ^~~~~~~~~~~~~~~~~~~~~~~

This function call was introduced backported with commit e9847175b266 
with the subject line "platform/x86/amd: pmc: Read SMU version during 
suspend on Cezanne systems".

Please note that amd_pmc_get_smu_version() is defined in an #ifdef 
CONFIG_DEBUG_FS block, but the new function call is compiled regardless 
of CONFIG_DEBUG_FS, causing the aforementioned error when building 
without the Debug Filesystem.


Best regards,
Jaak Ristioja
