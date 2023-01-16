Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515DD66C55B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjAPQFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:05:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjAPQEs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:04:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7FA2686B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:03:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23615B80DF9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF9BC433EF;
        Mon, 16 Jan 2023 16:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884989;
        bh=pvltEXSiUFC9diafDbsx26spIIwbWPkznqU+5td83ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XmdQBuKw6f61gmjQqcdPMBrn+nBrRK3mP6ITZvbf6ghmx1x0WtN4fl89kXd/oEC0g
         kjoNAL8swmcZ7FT5nszu7H5E/VzECnUUbT3lIwgcPAZk8i+ZtG5QzbnJcoQUqn9h2t
         4vthg2wPwe+J8EjxDJ9XdkRChQpmedZknVq4UGig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jinrong Liang <cloudliang@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15 07/86] selftests: kvm: Fix a compile error in selftests/kvm/rseq_test.c
Date:   Mon, 16 Jan 2023 16:50:41 +0100
Message-Id: <20230116154747.362531821@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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

From: Jinrong Liang <cloudliang@tencent.com>

commit 561cafebb2cf97b0927b4fb0eba22de6200f682e upstream.

The following warning appears when executing:
	make -C tools/testing/selftests/kvm

rseq_test.c: In function ‘main’:
rseq_test.c:237:33: warning: implicit declaration of function ‘gettid’; did you mean ‘getgid’? [-Wimplicit-function-declaration]
          (void *)(unsigned long)gettid());
                                 ^~~~~~
                                 getgid
/usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined reference to `gettid'
collect2: error: ld returned 1 exit status
make: *** [../lib.mk:173: ../kvm/tools/testing/selftests/kvm/rseq_test] Error 1

Use the more compatible syscall(SYS_gettid) instead of gettid() to fix it.
More subsequent reuse may cause it to be wrapped in a lib file.

Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Message-Id: <20220802071240.84626-1-cloudliang@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/kvm/rseq_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -233,7 +233,7 @@ int main(int argc, char *argv[])
 	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker,
-		       (void *)(unsigned long)gettid());
+		       (void *)(unsigned long)syscall(SYS_gettid));
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vm, VCPU_ID);


