Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1DA50D98E
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 08:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiDYGlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 02:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiDYGlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 02:41:06 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD566CC
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 23:38:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id s14so24806859plk.8
        for <stable@vger.kernel.org>; Sun, 24 Apr 2022 23:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0/mOWNXzW38dg8R0fVtw4b3MwrVtNp67q4q4XoFVG3w=;
        b=DAfcQvgpCUKzoBOBzQgDc7nAMOtoGx1tyNvMD+IwheC0zh/yNo/uWbDnEcyIgf4PAS
         UZRoPdxbEgx2sCChvorRj1cQNcdpbIp/LVBfTm6PQrCBXUD5QS1OCEgCm5L53H1NvppE
         1XJ8jXgjChQK4RKJH1fNhkPgppY/j/ucaoiC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0/mOWNXzW38dg8R0fVtw4b3MwrVtNp67q4q4XoFVG3w=;
        b=NWb4m1yMKKHgiW8qi65nd1/12F6k4M84hp+5olO6sf2grSCTbJn+CmMBE5IgNnnZea
         NGCNzU8eeFbcm1le3E6qYvU4nS82LUe+HKvTvG2mU4KAXmiQ+ptuMHEeq//YvTgfgRrm
         8fD+GasoTDR1thXq6mTT+Z6ZFIQvEJIOVijak6UGAf1RVMzaeN1rtLklQ01J01thvjb4
         36X24yN7bydPhFLTQcLIkJOLzgkooemeJK/Fqx/oBQ2lgGl0pKegIKpzqmNQ6rUdfjwA
         YtAElwD5MR1kB96KiIVsX2b0R+PaAoSjxBkj/i0qi45QPgzv0YHxthj5VsDjynE43cGZ
         quuA==
X-Gm-Message-State: AOAM533ytkcsIlNwcvl7vaSwb+frIUxLWeWLHL5ezM/TFN2R4lu/ZuDR
        k+QL3fijdpShTFDKiUK2558+Og==
X-Google-Smtp-Source: ABdhPJwQzgg+yRgAON+In2XY7dDU4M9sH6VEsgHQdivbGpwVrEG3MmHunARuxftfopoxtAWVxUf36A==
X-Received: by 2002:a17:902:bcc2:b0:14f:23c6:c8c5 with SMTP id o2-20020a170902bcc200b0014f23c6c8c5mr16426067pls.131.1650868683136;
        Sun, 24 Apr 2022 23:38:03 -0700 (PDT)
Received: from saltlake.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.gmail.com with ESMTPSA id m12-20020a62a20c000000b0050af5c925c3sm10212808pff.132.2022.04.24.23.38.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 23:38:02 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     mhiramat@kernel.org, keitasuzuki.park@sslab.ics.keio.ac.jp,
        stable@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] tracing: Fix potential double free in create_var_ref()
Date:   Mon, 25 Apr 2022 06:37:38 +0000
Message-Id: <20220425063739.3859998-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220423001311.31e2dff59708ddd3043e55af@kernel.org>
References: <20220423001311.31e2dff59708ddd3043e55af@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In create_var_ref(), init_var_ref() is called to initialize the fields
of variable ref_field, which is allocated in the previous function call
to create_hist_field(). Function init_var_ref() allocates the
corresponding fields such as ref_field->system, but frees these fields
when the function encounters an error. The caller later calls
destroy_hist_field() to conduct error handling, which frees the fields
and the variable itself. This results in double free of the fields which
are already freed in the previous function.

Fix this by storing NULL to the corresponding fields when they are freed
in init_var_ref().

Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
CC: stable@vger.kernel.org
Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 kernel/trace/trace_events_hist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 44db5ba9cabb..a0e41906d9ce 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -2093,8 +2093,11 @@ static int init_var_ref(struct hist_field *ref_field,
 	return err;
  free:
 	kfree(ref_field->system);
+	ref_field->system = NULL;
 	kfree(ref_field->event_name);
+	ref_field->event_name = NULL;
 	kfree(ref_field->name);
+	ref_field->name = NULL;
 
 	goto out;
 }
-- 
2.25.1

