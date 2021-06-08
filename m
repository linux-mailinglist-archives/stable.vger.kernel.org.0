Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7F239FD4F
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhFHRPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 13:15:18 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:35652 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhFHRPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 13:15:17 -0400
Received: by mail-pg1-f177.google.com with SMTP id o9so14210000pgd.2
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 10:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsfQiWd97yOtmV8s3TncV+9PPnjyb/KIQiQemE+zye8=;
        b=lAbyMhf7YpRAuqY4tAMv7/brwjdlwNtfr+Mcg/sxOfs++wRgjKLM9PCQLpHqBgS9U4
         ZIsk57Lm32YYU0oOQk825Eka54WfUDgaX47FDF3XUrBrpsIBx7UWJqip/w4hJd/gEMMx
         CCDDBYH/Ps/nE97zYBlwHigVdNudtcIblJFIU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LsfQiWd97yOtmV8s3TncV+9PPnjyb/KIQiQemE+zye8=;
        b=rI/Av3PAmr2AekqZh66Eqyj+TvyXVsoGuMN8Vi1T0f/JzQCCXF946uUmNcPeuqE/31
         B6dn/BOSOK+t9cS9EHZfHfscLlL/8xsrrwlRdgiGOOB5xhKu1CF+KnTB5eT3gyeWYQB3
         t+I048SAv/2c7cuWoTQv//KBcQSVMdotdFVfPxjDek/EcaKji0jbPHdY2hG3EiPaoFif
         aOAV8zrIMxQMd56XBkB2fBP2gUt+21/SIZYhq4ioNIi6ZUwpQW06n8sQYl2W9D4k5J+S
         G5A4vqNRUH4URHq4tu9UYb3H6wXa3tXan2gm0RTWDdZjNe5xH/vSd0H/uXvA1+DJXJ4z
         xgeQ==
X-Gm-Message-State: AOAM531SCr2QHAanDKl3uOenApiAWUBdDparNd6gEkrcZ8YH5pcpFGqS
        +KqQW5HPk2eJIQNU8y7TQr0xKg==
X-Google-Smtp-Source: ABdhPJxBmc52fN5Fzl9HQxIOeIzImtBdpWptvHFr4JnebiLD20NAtCnwmZFY8u9PIU0XZhaLklEdPQ==
X-Received: by 2002:a62:2e04:0:b029:2db:4c99:614f with SMTP id u4-20020a622e040000b02902db4c99614fmr862818pfu.47.1623172344700;
        Tue, 08 Jun 2021 10:12:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c4sm1528336pfo.189.2021.06.08.10.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 10:12:24 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev
Subject: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
Date:   Tue,  8 Jun 2021 10:12:21 -0700
Message-Id: <20210608171221.276899-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=cab007d90ab2594b4813f56a3d3ec12879c5f4be; i=jUA78oRN/AMcDxOpnurfp4e2tGWh+F5DhA4jKTmbuSU=; m=5IH87NogdOjq9S6JPLku9CCKrPsDQaaCiq+A4siNk0Q=; p=uhi3mxYNybAOwPzHDVCoMxXbfTOvQcgY/re3LiUOVx0=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC/pPUACgkQiXL039xtwCb+shAAniU UwnXMZD1U1RjMQ/p2lXYkIH+p4j+rb7BmwMlvKzpTO/gzk55T7lk2EUIWwB4ymnNt5Sx51BoHRuJN 32HgVT24kYjM8xf7ZaSqzcktQr0hS+Bx+uHB9hW8VQ8sSrOFmTnuWOSGWpUt5GLJ6J3XTHWjZo1h3 wtDQXBv3945FDIECuMCIuQh0NTNtzFnmbVZmjQi8faPnbbkw9ATP9CWiELUDQBgWief97YzwEidov GaaQMe8a1Zv+/GP1BQz6q7ylAZSaGsy/1d7+GEo9xddGgFjN16uR5TUkKxLZ0bQ/gSGRVBqxc5Fwn FgASyURJXgtGf+nFRnhZtPB+tPb+/qxhYTlq8TTZAAayXjM4Ct5c6+KZLEhaY5FRC+A1xjjzh39GY Wxs57x1kESOBC7nF+U+ouKrL8B9rS9v6aFIovcgqDcZevWZv+FZb18b+cnpj+h7Ev83YIPnbh0xsq i1qzC11cogjCPBOD5oKTcy4pY6yru5dKIwLjoEdrjSEMnGiH2ieJwhCcxzrRYSslLr/oTMvrZP8NS Sg7wiv1hGQlvyvOPJtub/A60OWtNVIlX+9xoRSg38KW0BXVjIVBECkKA1MuIBj2V7OU4aCc9Yoc5W 3OwQ+mf8rPnhtvgLu2RII7KtUWZtbr2nWmF4Sm0018RfHscag1nR3wjdstQIos6w=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
tried to make sure that there could not be a confusion between the opener of
a /proc/$pid/attr/ file and the writer. It used struct cred to make sure
the privileges didn't change. However, there were existing cases where a more
privileged thread was passing the opened fd to a differently privileged thread
(during container setup). Instead, use mm_struct to track whether the opener
and writer are still the same process. (This is what several other proc files
already do, though for different reasons.)

Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Reported-by: Andrea Righi <andrea.righi@canonical.com>
Tested-by: Andrea Righi <andrea.righi@canonical.com>
Fixes: bfb819ea20ce ("proc: Check /proc/$pid/attr/ writes against file opener")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/base.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 58bbf334265b..7118ebe38fa6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2674,6 +2674,11 @@ static int proc_pident_readdir(struct file *file, struct dir_context *ctx,
 }
 
 #ifdef CONFIG_SECURITY
+static int proc_pid_attr_open(struct inode *inode, struct file *file)
+{
+	return __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
+}
+
 static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,
 				  size_t count, loff_t *ppos)
 {
@@ -2704,7 +2709,7 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 	int rv;
 
 	/* A task may only write when it was the opener. */
-	if (file->f_cred != current_real_cred())
+	if (file->private_data != current->mm)
 		return -EPERM;
 
 	rcu_read_lock();
@@ -2754,9 +2759,11 @@ static ssize_t proc_pid_attr_write(struct file * file, const char __user * buf,
 }
 
 static const struct file_operations proc_pid_attr_operations = {
+	.open		= proc_pid_attr_open,
 	.read		= proc_pid_attr_read,
 	.write		= proc_pid_attr_write,
 	.llseek		= generic_file_llseek,
+	.release	= mem_release,
 };
 
 #define LSM_DIR_OPS(LSM) \
-- 
2.25.1

