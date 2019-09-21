Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0740EB9BC6
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 03:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfIUBIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 21:08:05 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38153 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfIUBIF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 21:08:05 -0400
Received: by mail-io1-f65.google.com with SMTP id k5so20282073iol.5
        for <stable@vger.kernel.org>; Fri, 20 Sep 2019 18:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P6rSlkZ/6twdeJfNHRrBGgdxfePxiuleQDO4abOK0TM=;
        b=thh0y6heaAKJjFnJt8p7AJwUsEnLqWAPwvIVPcofLNDbDELZsoe5lW+C+lS2YMlQPN
         xHTR7Eq4LwHJUvAQLlp1DX5d8bnBHNU40SQGmxmvlBjaQzWYMRgjJVzZT7KDKKwqHgG1
         l8iOO61+brpiw9P5eNrxw4vIKVrEWPK+sKRIgtgmT+AjCHBmEhlSqCZt/reda2irRDt/
         mme0UQR0d6ZiotL5GRzBmlyzOVsb2nZc5SDXhJBLu4cXNQCcjRAkR5gk6scrx1Y0YDuf
         A/6kBz2RxnweLL8ipIJHc2vqEOot3dTAdVLK0XQD+TYcUcKQszZ2ASqlcHOqfn53wLfj
         TE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P6rSlkZ/6twdeJfNHRrBGgdxfePxiuleQDO4abOK0TM=;
        b=lLNYbnxe3IoHyvq+J4JB3GY+7busTDwnsfReHT/StxKxWSKoPHZ1tywQ34qoAHHNbV
         V3xRMgQ8cg50BN9oVAEZWhqnV4zrXlncH/wERmDK1YVZva4zkL1e37/cKqVDtUnOWxdJ
         23wtGi1lmgZkA12/doBWwBruDgo60Vh/5eew3tPHvFOXQK8wh+QKW20hgyymO2PnWywD
         MO1Z6c9DfVfzH+BKgow8MaeRuNsoCAUh8FjbtZKgENFRe3uXtLRpGh+1aT7wQQ3iqDWR
         WmR63dsvLz4iWjkxJzs+kxlccRwK0cHUY49sUJSPBQxTlzJJkx5qJhDx1alKwKkqPCIt
         LhWw==
X-Gm-Message-State: APjAAAXAop1qcwPi6qkgj8EkXYxZlME+ujEbk0goLP/0iGCInYFmOAVN
        FNkSwPox9AI2DaHwkb4A7zmg9G0sHuxGmA==
X-Google-Smtp-Source: APXvYqwLu9Ob6uR7Jqpq9miS9Izf2nmZKRS88ZuyN8aMPtnnAzGJzeg4dTAPSwIpX5xsNpnG5hQ2+A==
X-Received: by 2002:a5e:9917:: with SMTP id t23mr23288613ioj.141.1569028083988;
        Fri, 20 Sep 2019 18:08:03 -0700 (PDT)
Received: from gruber-ubuntu-acer.local ([50.54.39.105])
        by smtp.gmail.com with ESMTPSA id j11sm2367016ioa.55.2019.09.20.18.08.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 20 Sep 2019 18:08:03 -0700 (PDT)
From:   John S Gruber <johnsgruber@gmail.com>
X-Google-Original-From: John S Gruber <JohnSGruber@gmail.com>
To:     stable@vger.kernel.org
Cc:     John S Gruber <JohnSGruber@gmail.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        x86-ml <x86@kernel.org>
Subject: [PATCH] x86/boot: v4.4 stable and v4.9 stable boot failure due to dropped patch line
Date:   Fri, 20 Sep 2019 21:06:55 -0400
Message-Id: <1569028015-15344-1-git-send-email-JohnSGruber@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20190731054627.5627-2-jhubbard@nvidia.com>
References: <20190731054627.5627-2-jhubbard@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This regards upstream commit a90118c445cc ("x86/boot: Save fields
explicitly, zero out everything else") application to linux-stable.

Its corresponding commits to the stable 4.4 and 4.9 trees didn't apply
correctly, probably due to a field name change (e820_table had been named
e820_map before 4.10).

On my desktop I'm unable to boot a signed kernel due to these commits.

Add e820_map (to replace e820_table) to the preserved fields so that the
E820 memory regions in boot_params can be accessed by the kernel after
boot_params has been sanitized.

Signed-off-by: John S Gruber <JohnSGruber@gmail.com>
Fixes: 41664b97f46e ("x86/boot: Save fields explicitly, zero out everything else")
Fixes: 4e478cb2ccdd ("x86/boot: Save fields explicitly, zero out everything else")
Link: https://lore.kernel.org/lkml/20190731054627.5627-2-jhubbard@nvidia.com/
---

I tested stable 4.14.145, 4.19.74, and 5.2.16 successfully under the same
circumstances. Only 4.4 and 4.9 are affected by this dropped line.

 arch/x86/include/asm/bootparam_utils.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/bootparam_utils.h b/arch/x86/include/asm/bootparam_utils.h
index 0232b5a..588d8fb 100644
--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -71,6 +71,7 @@ static void sanitize_boot_params(struct boot_params *boot_params)
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
 			BOOT_PARAM_PRESERVE(hdr),
+			BOOT_PARAM_PRESERVE(e820_map),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};
 
-- 
2.7.4

