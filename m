Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79D9114E7AC
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 04:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgAaDst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 22:48:49 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42819 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgAaDst (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 22:48:49 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so2724966pgb.9;
        Thu, 30 Jan 2020 19:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lw805ccpp52QxN2MgYdVoxrp8refimhileg/aigHHME=;
        b=qgwRbCldkfdnA0agxUY6g9ytOOxSr5YJpr2efwpYgJ/Jwskok/iitcR1RQoYvj6YaJ
         pUlZi8R9EAIXelDxPEpO7rnXqcFryLBDUzWd5VkZXhQ1wfIzp8RQkl4RmIuC0/LmbD8/
         ao6oeFALCPjA0hAh8gapLJsst6bj/8LMyiz/Qxww+or4Kv4XL/bpyLgWEO54VeEeDie0
         40NsVcUgUQGdgKOLvUURJXzoOSNwpaDTLBl77rY6QmDVvUwgL1pd290OB6aUU74vbKms
         xfbsysZbewjKXSkJwpv1kChz51aO8V8pZezASsKBXyvLGzyrfRmmNpUkv9LjrTFeSk0o
         aCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=lw805ccpp52QxN2MgYdVoxrp8refimhileg/aigHHME=;
        b=naS7RKeEsaYhTfHAo1Vd2K/M9X/sZoMmClrJW5WtF7t4JafM6krx35BpV2fG0274X1
         sz6vtVZI4Pmcgm2v4OSc5WMgL3I7EXnIAaAJGuDRy/hj0yvwZTJBgzNnIny68adr0NCQ
         LS4WgYdhO7ubUfQ13nK1vGHW4zxGntXX3v13DxyluSKDlJR627dHgAuxUi+2dvIsTLkt
         hHthcy+CdtnZVVx9LobTryHDUhOOX12J+kB/NxAsc4rgw7TsuaMHGEgfiP8YjwHJm7pL
         kQGZUzRo97j5sZYS45O6LwT4VpLTHMXSrTD1uJd1Q33X9cr2SrE6o0AZcGyBZp1517q0
         gs9A==
X-Gm-Message-State: APjAAAW+SC3HMYpnXGR0kvzFYrYIhalnjENETAeHi5Dr7vDef/8VHja6
        ZwUDKPJ++dPOOxNDR+hAgkU=
X-Google-Smtp-Source: APXvYqyv+p0ZglaMSsbYR8fP6AjKovu4neIpvLenTX8hgjcdQnNcGR8c7B7A2Fk1ZXNv/v5+GWoDSA==
X-Received: by 2002:a63:ed01:: with SMTP id d1mr7469703pgi.95.1580442527163;
        Thu, 30 Jan 2020 19:48:47 -0800 (PST)
Received: from localhost.localdomain ([45.124.203.14])
        by smtp.gmail.com with ESMTPSA id a185sm8115951pge.15.2020.01.30.19.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jan 2020 19:48:46 -0800 (PST)
From:   Joel Stanley <joel@jms.id.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        linux-fsi@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] fsi: aspeed: add unspecified HAS_IOMEM dependency
Date:   Fri, 31 Jan 2020 14:18:32 +1030
Message-Id: <20200131034832.294268-1-joel@jms.id.au>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

Currently CONFIG_FSI_MASTER_ASPEED=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

ld: drivers/fsi/fsi-master-aspeed.o: in function `fsi_master_aspeed_probe':
drivers/fsi/fsi-master-aspeed.c:436: undefined reference to `devm_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Fixes: 606397d67f41 ("fsi: Add ast2600 master driver")
Cc: stable@vger.kernel.org
Reported-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
Greg, can you please pick this one up. Brendan has asked it be included
in 5.6.

 drivers/fsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/fsi/Kconfig b/drivers/fsi/Kconfig
index 92ce6d85802c..4cc0e630ab79 100644
--- a/drivers/fsi/Kconfig
+++ b/drivers/fsi/Kconfig
@@ -55,6 +55,7 @@ config FSI_MASTER_AST_CF
 
 config FSI_MASTER_ASPEED
 	tristate "FSI ASPEED master"
+	depends on HAS_IOMEM
 	help
 	 This option enables a FSI master that is present behind an OPB bridge
 	 in the AST2600.
-- 
2.24.1

