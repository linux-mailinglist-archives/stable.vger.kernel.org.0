Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39346D000D
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 11:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjC3JqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 05:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjC3Jpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 05:45:40 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F828A79
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:45:17 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id r11so74114151edd.5
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 02:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680169514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P0ZT4tLV4pwIFoJoCyH/LTIscOWlu6sttcJkFj6RAJg=;
        b=MKhXbw6KldDmbyijGdW2H7JuSKi026ZosGMSIpAUYa7SUhoSNajx2CAwoSK78pgnXv
         9F1Q9tXqHnihud+Axk0aABNgz4iHDjH0mabEzb78y0ER0Y9LmD+SwmoeJePo8qY4ZTp+
         nu/4byyaZZi3pZZV96rCwuaexyXd2rOqeDjNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680169514;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P0ZT4tLV4pwIFoJoCyH/LTIscOWlu6sttcJkFj6RAJg=;
        b=jkyxvXk7/d13ObR1v8MEDcA+vYxYBg5pciZXlbyVzcf3NPyL2LHcmk1dX6qnPBF1ln
         dgbwS17bB2sO36U6fEh2Nu2ZQ7SHGnkKD9i4+Yh/UTwM3cewgoNfMFdwFRnJB70JrsjP
         P08cJ0wYPLMms+WIODiXpBow+f9VRgdN6uAtpPyAzlIguEfzzOMgLWcyVQsqTwgbGL2C
         /b+9RkVhEkFbT9i95ifMVK1y+BrsTPLDyjXAnnoADd9Po5iCRbsig6z4laVTJaAqrGEP
         i+F3ifbtsa8R3hUf1D3orsvOFrW9C9wS/6lekCb4HW881WF1BrTcVQL+/tsWILVGDJSY
         xM0Q==
X-Gm-Message-State: AAQBX9dHRr0YipNMzCZD7yGOJ8N/EMqVwWxfpvnphCoCnse4Vfj057oi
        B++aAhL/SvSWrsFX2C6drJTlhQ==
X-Google-Smtp-Source: AKy350Y3MhdwISO0SGhTHGP0tjb+EgKW1gK7KqgVklHI9iPI6buZ2tIhiSHfYod7GWEdeKrys5UvhA==
X-Received: by 2002:a17:906:144a:b0:944:394:93f7 with SMTP id q10-20020a170906144a00b00944039493f7mr16259171ejc.61.1680169514692;
        Thu, 30 Mar 2023 02:45:14 -0700 (PDT)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:1396:ff5d:6e2a:df6d])
        by smtp.gmail.com with ESMTPSA id k9-20020a17090666c900b0092b606cb803sm17683616ejp.140.2023.03.30.02.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 02:45:14 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Thu, 30 Mar 2023 11:44:47 +0200
Subject: [PATCH v5 1/2] kexec: Support purgatories with .text.hot sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230321-kexec_clang16-v5-1-5563bf7c4173@chromium.org>
References: <20230321-kexec_clang16-v5-0-5563bf7c4173@chromium.org>
In-Reply-To: <20230321-kexec_clang16-v5-0-5563bf7c4173@chromium.org>
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     Baoquan He <bhe@redhat.com>, Philipp Rudo <prudo@redhat.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ross Zwisler <zwisler@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Simon Horman <horms@kernel.org>,
        Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2485; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=l/5U4QEZ8HewezM0SKo7DhSrv7EPFo5/mMqWDXwDLoo=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkJVofL0ZHdw3ddeiqI0n8LoN5gHxlFKFxXyM1S
 urlJaHanIOJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZCVaHwAKCRDRN9E+zzrE
 iBg1D/91C6RHT9QE0cVG0e+v65DsVYnvrTBce1q5oPhLB+VmdQz1sThWgK+n/xYoYX9kPacvf/z
 6IDhkaLhHIQUVpdlui544DRnz6ShOt/8I3rM8gWQ4rD8jSJ52Qgc6Jd4CZu9gphgilDDor3kf+U
 gELhcxQkcHt+WlPPSiUYJ1cQw2LJWGMJiK1Pdosh6xEMM/lIz3zvuRTZz1ww/UhJ6CRQ5R9wyi8
 6N8DggUWF8LDooOKLv1tDJptKXtOiyTqCrjjFUQ8oqK3DEcSsy3lvHTg42bJFqLanTknUJrsCU0
 f5OLuScX7v2fZKP6t/RzVbNJbNoMBc1BWVYsoqieeMxwHnEBeCzL/nhDjCgsawICPSJbkkbNH4A
 PIBr5S7JcxPJ+AAK1wDC7gSiv80UNRE093oL2GFWo6D4osNDiqWDAPGtEv25dLIqMpQ6YbbkCYa
 iM5Opq0IJXCKm+Zd8jJQO8/PwXnR5TgHsf4OeYYUAm45oEyBEr5F9XYgR9mvDLbGKMCY1wmRN8t
 2RB1yHeR6VtZpkUdsFQfEfqD8w5jjh/qGLn77FIjPqh49Y64YZH0pdqscm1wpaHQYpJLFphTt/E
 PMV5yLjcLpgHIPop1pIp8gYl4cnmsm8T2+dAUcp1Jfj9CPUk6EenylzOoGoT+nk4Rq/fIP3CYL8
 dgSeZj8HENys/Ww==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Clang16 links the purgatory text in two sections:

  [ 1] .text             PROGBITS         0000000000000000  00000040
       00000000000011a1  0000000000000000  AX       0     0     16
  [ 2] .rela.text        RELA             0000000000000000  00003498
       0000000000000648  0000000000000018   I      24     1     8
  ...
  [17] .text.hot.        PROGBITS         0000000000000000  00003220
       000000000000020b  0000000000000000  AX       0     0     1
  [18] .rela.text.hot.   RELA             0000000000000000  00004428
       0000000000000078  0000000000000018   I      24    17     8

And both of them have their range [sh_addr ... sh_addr+sh_size] on the
area pointed by `e_entry`.

This causes that image->start is calculated twice, once for .text and
another time for .text.hot. The second calculation leaves image->start
in a random location.

Because of this, the system crashes immediately after:

kexec_core: Starting new kernel

Cc: stable@vger.kernel.org
Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 kernel/kexec_file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f1a0e4e3fb5c..c7a0e51a6d87 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -901,10 +901,22 @@ static int kexec_purgatory_setup_sechdrs(struct purgatory_info *pi,
 		}
 
 		offset = ALIGN(offset, align);
+
+		/*
+		 * Check if the segment contains the entry point, if so,
+		 * calculate the value of image->start based on it.
+		 * If the compiler has produced more than one .text section
+		 * (Eg: .text.hot), they are generally after the main .text
+		 * section, and they shall not be used to calculate
+		 * image->start. So do not re-calculate image->start if it
+		 * is not set to the initial value, and warn the user so they
+		 * have a chance to fix their purgatory's linker script.
+		 */
 		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
 		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
 		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
-					 + sechdrs[i].sh_size)) {
+					 + sechdrs[i].sh_size) &&
+		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {
 			kbuf->image->start -= sechdrs[i].sh_addr;
 			kbuf->image->start += kbuf->mem + offset;
 		}

-- 
2.40.0.348.gf938b09366-goog

