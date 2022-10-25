Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B8A60C60F
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 10:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbiJYIGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 04:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJYIGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 04:06:49 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E450F27FCB;
        Tue, 25 Oct 2022 01:06:48 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id u6so10512566plq.12;
        Tue, 25 Oct 2022 01:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vPfeIOnH88kn1I6LEWIx4+O89LWyMUX6PP8J5qkqHXo=;
        b=kUPfnkaUXxS01TDRyvPRj0kL9eeAJW+TfMEwIgBhwsUgL8C4dS9sNVaLadJWBCsqQQ
         ijaqB6EL9HKToe+fHajs6+VHZSzVljT2HqIL0BjnhJ/6SlhaDQWWZpbvMfG6uk/kvFL+
         9g5g4hi12Cifb1ySMhKxaAA92B/h7cCGW8ukmXm0gA7aZTpeFE+3tm0zXTqE5Ia6Bhlt
         LfXRdab8WwR5qFhq0oKPogeacKDTSDyIk0zKeuwi5m0+GjiLIL+njcn99mf/cnZxqJhM
         Wb09eO7z45Y8yYn0jIgYsGWoadW8Bu7EzZ9VPd8CVTGl2rhuqkL6TWfkFhlSCS++b+1z
         o3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vPfeIOnH88kn1I6LEWIx4+O89LWyMUX6PP8J5qkqHXo=;
        b=3e3WqYp9d+RDvL9Dv/C9IodiEcdRpH+TNV4rbk5VHIvCtcVMEQE6BhzGtfeibQY7ew
         VmOh8zHEj0s7/q/Ajm141zBT2e0Ef9Kn6eJZ1Kh52mCRDlSFSg/oRcRrblEhA0uU0nfd
         AKcA1ok9jPtSUsMx4QUQvKc7PgBtvIVB7MkMu7AEOFG65F7W4Bp6KxMnqlogeBPjK5hX
         nwP7GAQKzclu6eDXisDKQOihVknMUQTz05+0xoSRfTK10rZ+ycbPoH/0Sirtt2++dmvm
         rwbOaugJWxhpv7e5IlbY6/hdVjNUVPXKr7BVJnZvbiF6r3DKR/YnqtfRPJnJScIuTWYD
         50hw==
X-Gm-Message-State: ACrzQf1McZe88tLottTkZEl/vEzOjAvo3ofGCE83nw7AMW17MyOjRBmq
        KLb3PW0cL15Yw7gUKyM/Mjc=
X-Google-Smtp-Source: AMsMyM6nCyMg560kE/emgwbJlAgztrLGC8bQt8khPq+gne4CVwjmKfMaPlYB1EMfC13voRgAC3w6hg==
X-Received: by 2002:a17:90a:64c3:b0:212:d67d:a034 with SMTP id i3-20020a17090a64c300b00212d67da034mr22818982pjm.55.1666685208351;
        Tue, 25 Oct 2022 01:06:48 -0700 (PDT)
Received: from localhost.localdomain ([47.242.114.172])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902650600b0017f778d4543sm767473plk.241.2022.10.25.01.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 01:06:47 -0700 (PDT)
From:   Chuang Wang <nashuiliang@gmail.com>
Cc:     Chuang Wang <nashuiliang@gmail.com>, stable@vger.kernel.org,
        Song Liu <song@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Clean up all resources when register_fprobe_ips returns an error
Date:   Tue, 25 Oct 2022 16:06:28 +0800
Message-Id: <20221025080628.523300-1-nashuiliang@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When register_fprobe_ips returns an error, bpf_link_cleanup just cleans
up bpf_link_primer's resources and forgets to clean up
bpf_kprobe_multi_link, addrs, cookies.

So, by adding 'goto error', this ensures that all resources are cleaned
up.

Cc: stable@vger.kernel.org
Fixes: 0dcac2725406 ("bpf: Add multi kprobe link")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1ed08967fb97..5b806ef20857 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -2778,7 +2778,7 @@ int bpf_kprobe_multi_link_attach(const union bpf_attr *attr, struct bpf_prog *pr
 	err = register_fprobe_ips(&link->fp, addrs, cnt);
 	if (err) {
 		bpf_link_cleanup(&link_primer);
-		return err;
+		goto error;
 	}
 
 	return bpf_link_settle(&link_primer);
-- 
2.34.1

