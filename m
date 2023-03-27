Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822BB6CA895
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 17:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbjC0PHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 11:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjC0PHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 11:07:10 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F921FDE
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id er18so26283133edb.9
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 08:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679929627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D4LtynCWvRc0UC/GbC/kiRSwfX8IErgGFnov9fH0MI4=;
        b=SeR8XpvJmFC7LdsZqO8PftPdO/WoEdoLnRyq0aSn9RvbLTOVIM0I+Uy/lTlIGFgZP0
         QgZOH4KxGsX91xq39mn7GToV2aXvzURLfKScT12mKf8Ud7UUs21OTnHk1uM3pMAppgQh
         nMnbh2WoNeFYQK8A2bs/7k1d5yB+8KYm0cEP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679929627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4LtynCWvRc0UC/GbC/kiRSwfX8IErgGFnov9fH0MI4=;
        b=w5dbsv5cXFh69rImY40sYqkPE71VEKKqij0yjHUbJBN7iY4oy+04sfh0brkB458qzP
         C3iry8vtXQAVL6lIU5eo7avP6fFQcwcyZcnZWU4lWrR7fxldYZNg+n62Ot93USd3Tl4R
         A/R2oAmrnVwKTVPT6H10JPr9W4/0BYL1RZp92B144x/8Oz6pN1HV8l6CXdMCb4p4hBvl
         gImAMakPgiUGjcszwMAeVAZ55AuiaveXY2YNhavMQWE0QBI4cEssogmJ5xz5qx4SsfjS
         OIwLoUH3Q2yAGD3C0zHCt/tbc0lQy8rnfbHLA634+MqQ7eM+s6KoZnsT5R0dIR+qRD5j
         TkxQ==
X-Gm-Message-State: AAQBX9cDh5sH3ONjlpKyzenv9rxeeqHOd+4y/7/upjWyXoWEf1Qpc06G
        uiK9rfRgqilTL/u1yiOY0ZraNQ==
X-Google-Smtp-Source: AKy350aHovDlzgLgs115P/SJOsWOUsjm1h0t/Ir5MUx++aga7vNfpyg32h+1NDHEjm8ivB/B9d1uXA==
X-Received: by 2002:aa7:c54f:0:b0:4fa:4bc4:a911 with SMTP id s15-20020aa7c54f000000b004fa4bc4a911mr12553566edr.13.1679929627312;
        Mon, 27 Mar 2023 08:07:07 -0700 (PDT)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:ed3c:5e9e:b8e4:8695])
        by smtp.gmail.com with ESMTPSA id t9-20020a50c249000000b005021d1ae6adsm5312428edf.28.2023.03.27.08.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 08:07:07 -0700 (PDT)
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Mon, 27 Mar 2023 17:06:53 +0200
Subject: [PATCH v4 1/2] kexec: Support purgatories with .text.hot sections
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230321-kexec_clang16-v4-1-1340518f98e9@chromium.org>
References: <20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org>
In-Reply-To: <20230321-kexec_clang16-v4-0-1340518f98e9@chromium.org>
To:     Eric Biederman <ebiederm@xmission.com>
Cc:     linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Ricardo Ribalda <ribalda@chromium.org>,
        Philipp Rudo <prudo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, kexec@lists.infradead.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=2330; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=Ei7yD2n0waFqw7CoS4vSLL1z8Jz5Bb9trLKry0qiinI=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBkIbEWxcy3B0iTPJoJZfWXxHifMkAgvOzFX4C1Aerk
 unaFyXiJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCZCGxFgAKCRDRN9E+zzrEiPlpD/
 4xdjzkJcT2YBJrKe5K8kUeZunIKRIaZcU1T0vmQaW/gAAnb5Q4nb7q5RN98Kjn7/hfW1GJqG4QmKlQ
 CHL5TS07IZKvJZJG3R7fgUO+4iEbugW051COhuGNppdWZBbSuqb4loquF5yBWNueEHDoTkAjN9RM4Z
 t1wWEzEGn5g8DCBC3ppMSBIDsLfA4htdBMsT1cmuxXTkcpundBPg30B0OJoMS3Gl+syPsjaoSPxLCU
 ldl68qHqp3daJmfAinSvIQMdcO7LRU5L/gH1vb169QVxFlyqBRMRDNG40qxUy+Sthro74tSunoDpwc
 HvYylBBLyDsBlPy+sJn5bH1NYVHfR4DDgqnAMA3mspPxd7C++A7tHNXwRPMCZh18tZ3ubPspRKQX0t
 menr++Tglz9sHfiYr5ODn7s7NNYkPl26+DBi8IGVh6TVLlRlEm9nYTb79xiyzQWR0FDQ8eMENitsyj
 PiQB4wkHjMPfQYJpV2QvyhseHaRpWxpbDT7xZ59QLLniImh+AjzrTMTWXA1za7N59SqZ4b0TzWhdB+
 4eqK5d8m9WPJ7aaFh35lyFudOKRlE7FWToHEsP/od/1Iych5C02gaXTPfhITIp7tlkVspW7j/2O0U/
 euo8nzE58m4B7Q/xBSBg9EqfJD8MNV4BkZDq/JGR1om/3a84hAzqEsVaMCMQ==
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

Because of this, the system crashes inmediatly after:

kexec_core: Starting new kernel

Cc: stable@vger.kernel.org
Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 kernel/kexec_file.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f1a0e4e3fb5c..25a37d8f113a 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -901,10 +901,21 @@ static int kexec_purgatory_setup_sechdrs(struct purgatory_info *pi,
 		}
 
 		offset = ALIGN(offset, align);
+
+		/*
+		 * Check if the segment contains the entry point, if so,
+		 * calculate the value of image->start based on it.
+		 * If the compiler has produced more than one .text sections
+		 * (Eg: .text.hot), they are generally after the main .text
+		 * section, and they shall not be used to calculate
+		 * image->start. So do not re-calculate image->start if it
+		 * is not set to the initial value.
+		 */
 		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
 		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
 		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
-					 + sechdrs[i].sh_size)) {
+					 + sechdrs[i].sh_size) &&
+		    kbuf->image->start == pi->ehdr->e_entry) {
 			kbuf->image->start -= sechdrs[i].sh_addr;
 			kbuf->image->start += kbuf->mem + offset;
 		}

-- 
2.40.0.348.gf938b09366-goog-b4-0.11.0-dev-696ae
