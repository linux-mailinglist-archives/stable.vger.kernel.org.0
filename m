Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91811111BED
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbfLCWih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbfLCWie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:38:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6D6320684;
        Tue,  3 Dec 2019 22:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412714;
        bh=fGEGqqPn/RtkHfVgz6CHl74WTaoHeZ1ndAUeCWAUmQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x1xHkXLsxJiOKHjxvJfUBvkCuaTWl2OKC39BdKvTJO2Z1sR75Faygnq+4l37IZxUr
         qTa3xcjuynsOvtuA8ExMmCBiw9dMBTNIvdN7RlBVdoEbDKzF+O7NbTLueJQ6KFnJ+H
         FTpxlZouHsvuNFH6aedlW9pq+P61dLAX8uUIkBs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 35/46] selftests: bpf: test_sockmap: handle file creation failures gracefully
Date:   Tue,  3 Dec 2019 23:35:55 +0100
Message-Id: <20191203212756.099294275@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
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


