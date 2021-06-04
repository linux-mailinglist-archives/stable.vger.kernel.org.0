Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974B039BBBA
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 17:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFDPZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 11:25:45 -0400
Received: from mail-ej1-f45.google.com ([209.85.218.45]:46762 "EHLO
        mail-ej1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFDPZp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 11:25:45 -0400
Received: by mail-ej1-f45.google.com with SMTP id b9so15030727ejc.13;
        Fri, 04 Jun 2021 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mdtQ42ZqV6kSWyMlaYCk3ZTM4zdnZjaKRpszophbqHY=;
        b=nbqpnL+qOxNeYmEjuRyIAbnmeLIthnPSIYxgV3boyA2+HW4S1Y22Li/wwD7PE39iEP
         HpAcY/60nqn4Cs+4vP+CCEZJbkJss16wa9dkP8duTEbxndEl9CT0t6bEJyjvAXb40nHJ
         P/Yy5bmxWU3dP0Uh1W0CsTUV6uWGJyCghsm15oPSKqrpr6L5wrBvQLaaFQKoEo0/ka/y
         l8/j6byl4xiCeLGb/xBFuommDPxs+bVZzVwhUyaKl4lI8G3Q3oiiGd7qrX0mcJw09teQ
         8lUjIU1Nd5x4lG44gYn7FsggIkfJxPhkq6MTqTRORRtglqH9n60PRUYb8/pv/vRJsV03
         STCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mdtQ42ZqV6kSWyMlaYCk3ZTM4zdnZjaKRpszophbqHY=;
        b=qbvFXGdBrmKryGos7opHdQPyeILDw77hba+BOVDBOgiFr8JM2fA9LwWdkqXvWUW+C+
         1d/S6DCXy0QeP5GSFImmI9+Dk7Hs3c8KwjgMfWy6vAv35yoAedk3dZjAVpolt1P7hzl2
         TeoHo+g8lrbpZx2BehiGjGw9giLulr8qrPE3g9nF/T13Hy1Iaa1+r0p3ZQQtxrAgsLYP
         vAK/C4Jh+miDhs7K6CO4C1Cb/5Xsh7Tleg5oUO75SdB1KNl5nwrhLXlkfUm6CZdl8VMc
         Lu9HjCq2BX1eoCjJ8Swn/L1d37XBZC/alreEdKqG0cpJXwFffaysLt915aieiGDhr2e9
         QFPg==
X-Gm-Message-State: AOAM532h3TLTpl+DvI//SkgeZ47hyNR6GIIoBO8psG4fXcbU3I+ribGb
        iCH5Fd3yA3mg1gt6p+sC7U32cerN/KY=
X-Google-Smtp-Source: ABdhPJxajTjGvIJGMYVhBArrnbvaqQsQz2N7FdF/N4NQ9sU+Szxigc0BrNFZyFLexZfpIGk0+eX3lw==
X-Received: by 2002:a17:907:20da:: with SMTP id qq26mr4529274ejb.42.1622820165389;
        Fri, 04 Jun 2021 08:22:45 -0700 (PDT)
Received: from [192.168.178.194] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id w17sm3333128edd.44.2021.06.04.08.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 08:22:44 -0700 (PDT)
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Subject: [PATCH] ACPI: EC: Look for ECDT EC after calling acpi_load_tables()
Message-ID: <eeb5ebeb-5313-3763-7b5b-8701e582f1fc@gmail.com>
Date:   Fri, 4 Jun 2021 17:22:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b1c0330823fe upstream.

Backport of ACPI fix for #199981 for linux-4.9.y, tested on an Asus 
EeePC 1005PE running Debian Buster.

Some systems have had functional issues since commit 5a8361f7ecce
(ACPICA: Integrate package handling with module-level code) that,
among other things, changed the initial values of the
acpi_gbl_group_module_level_code and acpi_gbl_parse_table_as_term_list
global flags in ACPICA which implicitly caused acpi_ec_ecdt_probe() to
be called before acpi_load_tables() on the vast majority of platforms.

Namely, before commit 5a8361f7ecce, acpi_load_tables() was called from
acpi_early_init() if acpi_gbl_parse_table_as_term_list was FALSE and
acpi_gbl_group_module_level_code was TRUE, which almost always was
the case as FALSE and TRUE were their initial values, respectively.
The acpi_gbl_parse_table_as_term_list value would be changed to TRUE
for a couple of platforms in acpi_quirks_dmi_table[], but it remained
FALSE in the vast majority of cases.

After commit 5a8361f7ecce, the initial values of the two flags have
been reversed, so in effect acpi_load_tables() has not been called
from acpi_early_init() any more.  That, in turn, affects
acpi_ec_ecdt_probe() which is invoked before acpi_load_tables() now
and it is not possible to evaluate the _REG method for the EC address
space handler installed by it.  That effectively causes the EC address
space to be inaccessible to AML on platforms with an ECDT matching the
EC device definition in the DSDT and functional problems ensue in
there.

Because the default behavior before commit 5a8361f7ecce was to call
acpi_ec_ecdt_probe() after acpi_load_tables(), it should be safe to
do that again.  Moreover, the EC address space handler installed by
acpi_ec_ecdt_probe() is only needed for AML to be able to access the
EC address space and the only AML that can run during acpi_load_tables()
is module-level code which only is allowed to access address spaces
with default handlers (memory, I/O and PCI config space).

For this reason, move the acpi_ec_ecdt_probe() invocation back to
acpi_bus_init(), from where it was taken away by commit d737f333b211
(ACPI: probe ECDT before loading AML tables regardless of module-level
code flag), and put it after the invocation of acpi_load_tables() to
restore the original code ordering from before commit 5a8361f7ecce.

Fixes: 5a8361f7ecce ("ACPICA: Integrate package handling with 
module-level code")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=199981
Reported-by: step-ali <sunmooon15@gmail.com>
Reported-by: Charles Stanhope <charles.stanhope@gmail.com>
Tested-by: Charles Stanhope <charles.stanhope@gmail.com>
Reported-by: Paulo Nascimento <paulo.ulusu@googlemail.com>
Reported-by: David Purton <dcpurton@marshwiggle.net>
Reported-by: Adam Harvey <adam@adamharvey.name>
Reported-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Jean-Marc Lenoir <archlinux@jihemel.com>
Tested-by: Laurentiu Pancescu <laurentiu@laurentiupancescu.com>
Signed-off-by: Laurentiu Pancescu <laurentiu@laurentiupancescu.com>
---
  drivers/acpi/bus.c | 23 ++++++++++++-----------
  1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 92a146861086..cc88571c2cac 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1133,17 +1133,6 @@ static int __init acpi_bus_init(void)

  	acpi_os_initialize1();

-	/*
-	 * ACPI 2.0 requires the EC driver to be loaded and work before
-	 * the EC device is found in the namespace (i.e. before
-	 * acpi_load_tables() is called).
-	 *
-	 * This is accomplished by looking for the ECDT table, and getting
-	 * the EC parameters out of that.
-	 */
-	status = acpi_ec_ecdt_probe();
-	/* Ignore result. Not having an ECDT is not fatal. */
-
  	if (acpi_gbl_execute_tables_as_methods ||
  	    !acpi_gbl_group_module_level_code) {
  		status = acpi_load_tables();
@@ -1154,6 +1143,18 @@ static int __init acpi_bus_init(void)
  		}
  	}

+	/*
+	 * ACPI 2.0 requires the EC driver to be loaded and work before the EC
+	 * device is found in the namespace.
+	 *
+	 * This is accomplished by looking for the ECDT table and getting the EC
+	 * parameters out of that.
+	 *
+	 * Do that before calling acpi_initialize_objects() which may trigger EC
+	 * address space accesses.
+	 */
+	acpi_ec_ecdt_probe();
+
  	status = acpi_enable_subsystem(ACPI_NO_ACPI_ENABLE);
  	if (ACPI_FAILURE(status)) {
  		printk(KERN_ERR PREFIX
-- 
2.20.1

