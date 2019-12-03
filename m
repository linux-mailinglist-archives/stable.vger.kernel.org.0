Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D774C111C8B
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfLCWpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:45:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbfLCWpI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86E89207DD;
        Tue,  3 Dec 2019 22:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413108;
        bh=fGEGqqPn/RtkHfVgz6CHl74WTaoHeZ1ndAUeCWAUmQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7sHPR4EZOrZtTu16ZIAuLBQDEbAOYqfbfc7LhXyYVbkfnRZLCLpSjwig78qHFe86
         jDwAanLRhLT5yDRriWdkWAz/Ef76IXwLJHv/tsVdRBJvSdmXdJPokEd2YDhSvNKB4l
         m2RdsBJtlKah+85wjb4rz4Gxd3kHoV0tbpZpmRIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 128/135] selftests: bpf: test_sockmap: handle file creation failures gracefully
Date:   Tue,  3 Dec 2019 23:36:08 +0100
Message-Id: <20191203213045.237909265@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 4b67c515036313f3c3ecba3cb2babb9cbddb3f85 ]

test_sockmap creates a temporary file to use for sendpage.
this may fail for various reasons. Handle the error rather
than segfault.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_sockmap.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -332,6 +332,10 @@ static int msg_loop_sendpage(int fd, int
 	int i, fp;
 
 	file = fopen(".sendpage_tst.tmp", "w+");
+	if (!file) {
+		perror("create file for sendpage");
+		return 1;
+	}
 	for (i = 0; i < iov_length * cnt; i++, k++)
 		fwrite(&k, sizeof(char), 1, file);
 	fflush(file);
@@ -339,6 +343,11 @@ static int msg_loop_sendpage(int fd, int
 	fclose(file);
 
 	fp = open(".sendpage_tst.tmp", O_RDONLY);
+	if (fp < 0) {
+		perror("reopen file for sendpage");
+		return 1;
+	}
+
 	clock_gettime(CLOCK_MONOTONIC, &s->start);
 	for (i = 0; i < cnt; i++) {
 		int sent = sendfile(fd, fp, NULL, iov_length);


