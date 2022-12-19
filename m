Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2022651310
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiLST1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiLST0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EB6329
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46326109A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D9C433D2;
        Mon, 19 Dec 2022 19:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477976;
        bh=Hbq50VbUFEVVqKD0Q5oDKqIw7LVPtOiJhJHjvE8rWLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mURVp8HcCte54BeFcDJrtUi1Gt69kynQgdZ/gNVQ0d9UQT4TWMQdtZD01hupw+IzJ
         IB01Iuv7EdpsHwctQHkN1paJLn+eDlq2ekLFfpsSCbQjmSujV4McOz/dlRcdZCiddJ
         iGoKWRs+dkIR2TXV+smoonD2XkOEIH+KT/7IJI9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Song Liu <song@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.0 07/28] selftests/bpf: Add bpf_testmod_fentry_* functions
Date:   Mon, 19 Dec 2022 20:22:54 +0100
Message-Id: <20221219182944.492514965@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit fee356ede980b6c2c8db612e18b25738356d6744 upstream.

Adding 3 bpf_testmod_fentry_* functions to have a way to test
kprobe multi link on kernel module. They follow bpf_fentry_test*
functions prototypes/code.

Adding equivalent functions to all bpf_fentry_test* does not
seems necessary at the moment, could be added later.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-7-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c |   24 ++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
+++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
@@ -88,6 +88,23 @@ __weak noinline struct file *bpf_testmod
 	}
 }
 
+noinline int bpf_testmod_fentry_test1(int a)
+{
+	return a + 1;
+}
+
+noinline int bpf_testmod_fentry_test2(int a, u64 b)
+{
+	return a + b;
+}
+
+noinline int bpf_testmod_fentry_test3(char a, int b, u64 c)
+{
+	return a + b + c;
+}
+
+int bpf_testmod_fentry_ok;
+
 noinline ssize_t
 bpf_testmod_test_read(struct file *file, struct kobject *kobj,
 		      struct bin_attribute *bin_attr,
@@ -119,6 +136,13 @@ bpf_testmod_test_read(struct file *file,
 			return snprintf(buf, len, "%d\n", writable.val);
 	}
 
+	if (bpf_testmod_fentry_test1(1) != 2 ||
+	    bpf_testmod_fentry_test2(2, 3) != 5 ||
+	    bpf_testmod_fentry_test3(4, 5, 6) != 15)
+		goto out;
+
+	bpf_testmod_fentry_ok = 1;
+out:
 	return -EIO; /* always fail */
 }
 EXPORT_SYMBOL(bpf_testmod_test_read);


