Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28AF65DE17
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 22:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbjADVJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 16:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240313AbjADVJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 16:09:17 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C7F1DDD1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:09:15 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id c2so9629045plc.5
        for <stable@vger.kernel.org>; Wed, 04 Jan 2023 13:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N7e2wI5rOH0TCS8vVnB78L3eDotCSnHcKsvZPx9y4wU=;
        b=C40Gz9QcfmKE0+Yw+ZeeTtIoek8V2TWOtdR4AwnrKaklJs1/LZvWLUeB1itG4Ck7np
         NvAjiGYGr+Bgcu814J00sXqoYVsSICOnjmrhBRtx07jFQtcJ7pQUAVzh3jVRGTt0V192
         8p0dpcIHT8EpUHXJWkMhixUl1sAJWNWU12Q4M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7e2wI5rOH0TCS8vVnB78L3eDotCSnHcKsvZPx9y4wU=;
        b=4thOXOvaF2TeYHL4TdocDXGheO82v9bwhMjXFefgSG39gWvNFwgJVqKhG0Bdq8hbf2
         ZNOGLK6dxIrre4BF86T575gjhynYYpvOJ0zuO2qEgXQm6rVTB44yilfn4+VZGTpFXNwM
         F1x1xbMKWYw7hJvnR5iICDofi03iXxTT6oakjPxSzhPWIaSpVAFfrJkCG+KunXuMWb3L
         B1y708zJarQ0zxzAnteu/7Exv2s8/yad42umD5b383BN2I5hbNwrZps0kNiwpIP64pJo
         ETPNjsL9S9ZtKEQ1XSVbXQbeOESj2Mo8qcs3JFR1JbWfscXbjpgbIK/Gwdyw76wE7vGA
         0Hkw==
X-Gm-Message-State: AFqh2krMVMmK6DWy0B/Va8L71GIFug3t4Qt8e97H+i+6lBcPuu1qTaEH
        Wl8rQYXkQC+LzEgkq2zCSKBrbA==
X-Google-Smtp-Source: AMrXdXsS+rbrcdC8oxPFmFfnIHZhQwxagm363BI8RJ3ymU5GkpRbqX0sIx+1yKRH2LDDjk/ySqK3IQ==
X-Received: by 2002:a17:903:2682:b0:192:f12a:42de with SMTP id jf2-20020a170903268200b00192f12a42demr2516867plb.42.1672866554980;
        Wed, 04 Jan 2023 13:09:14 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d19-20020a656b93000000b00476dc914262sm20817436pgw.1.2023.01.04.13.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 13:09:14 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Kees Cook <keescook@chromium.org>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>,
        Riccardo Schirone <sirmy15@gmail.com>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH v2] ext4: Fix function prototype mismatch for ext4_feat_ktype
Date:   Wed,  4 Jan 2023 13:09:12 -0800
Message-Id: <20230104210908.gonna.388-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2508; h=from:subject:message-id; bh=rWss1AWpfgN5m5MJ3ZzB8riftLh8uHlWslxcv4hTtPQ=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjter33m3BUzBmkepopp8BSQH8S0ACYSatzHFDr43m Af3b0nKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCY7Xq9wAKCRCJcvTf3G3AJlFJD/ 4lw5d6tzW8szirp5AWtqCSAk2F8btgMJ0kn+otr52eFrv50d4FyF2DrGCrjKHW6TrCV5R1IbGuxzyC cNxeDeUXZ08+2+Z5coqXuQVIKi2ccgbzJXkcpJyBqidP6Q5EE/9jPxv1isYpI8Wx6pUqvFb3JC3JNU TxeGXpu1Etl3gs6tj+WVwfVrf3waEGXNvG7oVLMSK9SY2GMqJdQvBE2m8It9yxubznQVH4FcdUZkge WZiHcQxMTjJJvExrAJQMPCOZTGydwKp4sFIEfuBik8owEqDw+rp0pLWFDykwlB2gQ43H31hlfp5qvD ja0NSNl9ClP3XMtlAddoBVD83OAz5WM5QLRmjfkQZcLpeV4OoEhoLFkkPTOmhrtgYD4QR+oboFL5VJ bR+fyrp9wFy7sabuSYn7UD2SLENbyhyRQJ1Wq+KvK/POkLsr2q2OEyiFD5QxFhuJcQxqQjSu+dusLQ eQAXZxZNr2EY+gc/MsVQo82SCi1QUaYrz9iMWQBmPeUDvdzzPNg9HzV//sljmjTyt/lUfh+txYyN+D kqSNKiD/EKX27Rb/N8+6MRVLavRsCvZInKdmiJRsZ4m9Ht4fJQkF7+V+d+YDJkJHTdvyr2LdZK3GuT iZ9bjmYHTDnQQL+Ry+OxvAHK3To6Qg+N+G8ZLl8PsGiWtfPDv+XCmw+7WWmw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed.

ext4_feat_ktype was setting the "release" handler to "kfree", which
doesn't have a matching function prototype. Add a simple wrapper
with the correct prototype.

This was found as a result of Clang's new -Wcast-function-type-strict
flag, which is more sensitive than the simpler -Wcast-function-type,
which only checks for type width mismatches.

Note that this code is only reached when ext4 is a loadable module and
it is being unloaded:

 CFI failure at kobject_put+0xbb/0x1b0 (target: kfree+0x0/0x180; expected type: 0x7c4aa698)
 ...
 RIP: 0010:kobject_put+0xbb/0x1b0
 ...
 Call Trace:
  <TASK>
  ext4_exit_sysfs+0x14/0x60 [ext4]
  cleanup_module+0x67/0xedb [ext4]

Fixes: b99fee58a20a ("ext4: create ext4_feat kobject dynamically")
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org
Build-tested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20230103234616.never.915-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: rename callback, improve commit log (ebiggers)
v1: https://lore.kernel.org/lkml/20230103234616.never.915-kees@kernel.org
---
 fs/ext4/sysfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
index d233c24ea342..e2b8b3437c58 100644
--- a/fs/ext4/sysfs.c
+++ b/fs/ext4/sysfs.c
@@ -491,6 +491,11 @@ static void ext4_sb_release(struct kobject *kobj)
 	complete(&sbi->s_kobj_unregister);
 }
 
+static void ext4_feat_release(struct kobject *kobj)
+{
+	kfree(kobj);
+}
+
 static const struct sysfs_ops ext4_attr_ops = {
 	.show	= ext4_attr_show,
 	.store	= ext4_attr_store,
@@ -505,7 +510,7 @@ static struct kobj_type ext4_sb_ktype = {
 static struct kobj_type ext4_feat_ktype = {
 	.default_groups = ext4_feat_groups,
 	.sysfs_ops	= &ext4_attr_ops,
-	.release	= (void (*)(struct kobject *))kfree,
+	.release	= ext4_feat_release,
 };
 
 void ext4_notify_error_sysfs(struct ext4_sb_info *sbi)
-- 
2.34.1

