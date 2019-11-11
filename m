Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F72DF7CA0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729773AbfKKSsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbfKKSsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:48:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E73204FD;
        Mon, 11 Nov 2019 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498080;
        bh=magJWIIhJAta17rvJqjf/rR7U9jUmsF0pHTM+xeaEfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkFEEJHkBe/C2HFRdxX6VxD+rlGgJtR80RGkwIXD9M012Cuk6SdlFpUuCeku0ycPy
         JdXlJUlIrulaG/1vcVJeIpr9J6XK31cz+IM2a0juXdiMWJe2+P0EXsPAcUGOhdsGfK
         YESk58RHUNrPPzw0DZgqR+JXeTbnnRG/3O5KOdsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 017/193] selftests/tls: add test for concurrent recv and send
Date:   Mon, 11 Nov 2019 19:26:39 +0100
Message-Id: <20191111181501.432098820@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 41098af59d8d753aa8d3bb4310cc4ecb61fc82c7 ]

Add a test which spawns 16 threads and performs concurrent
send and recv calls on the same socket.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tls.c |  108 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -898,6 +898,114 @@ TEST_F(tls, nonblocking)
 	}
 }
 
+static void
+test_mutliproc(struct __test_metadata *_metadata, struct _test_data_tls *self,
+	       bool sendpg, unsigned int n_readers, unsigned int n_writers)
+{
+	const unsigned int n_children = n_readers + n_writers;
+	const size_t data = 6 * 1000 * 1000;
+	const size_t file_sz = data / 100;
+	size_t read_bias, write_bias;
+	int i, fd, child_id;
+	char buf[file_sz];
+	pid_t pid;
+
+	/* Only allow multiples for simplicity */
+	ASSERT_EQ(!(n_readers % n_writers) || !(n_writers % n_readers), true);
+	read_bias = n_writers / n_readers ?: 1;
+	write_bias = n_readers / n_writers ?: 1;
+
+	/* prep a file to send */
+	fd = open("/tmp/", O_TMPFILE | O_RDWR, 0600);
+	ASSERT_GE(fd, 0);
+
+	memset(buf, 0xac, file_sz);
+	ASSERT_EQ(write(fd, buf, file_sz), file_sz);
+
+	/* spawn children */
+	for (child_id = 0; child_id < n_children; child_id++) {
+		pid = fork();
+		ASSERT_NE(pid, -1);
+		if (!pid)
+			break;
+	}
+
+	/* parent waits for all children */
+	if (pid) {
+		for (i = 0; i < n_children; i++) {
+			int status;
+
+			wait(&status);
+			EXPECT_EQ(status, 0);
+		}
+
+		return;
+	}
+
+	/* Split threads for reading and writing */
+	if (child_id < n_readers) {
+		size_t left = data * read_bias;
+		char rb[8001];
+
+		while (left) {
+			int res;
+
+			res = recv(self->cfd, rb,
+				   left > sizeof(rb) ? sizeof(rb) : left, 0);
+
+			EXPECT_GE(res, 0);
+			left -= res;
+		}
+	} else {
+		size_t left = data * write_bias;
+
+		while (left) {
+			int res;
+
+			ASSERT_EQ(lseek(fd, 0, SEEK_SET), 0);
+			if (sendpg)
+				res = sendfile(self->fd, fd, NULL,
+					       left > file_sz ? file_sz : left);
+			else
+				res = send(self->fd, buf,
+					   left > file_sz ? file_sz : left, 0);
+
+			EXPECT_GE(res, 0);
+			left -= res;
+		}
+	}
+}
+
+TEST_F(tls, mutliproc_even)
+{
+	test_mutliproc(_metadata, self, false, 6, 6);
+}
+
+TEST_F(tls, mutliproc_readers)
+{
+	test_mutliproc(_metadata, self, false, 4, 12);
+}
+
+TEST_F(tls, mutliproc_writers)
+{
+	test_mutliproc(_metadata, self, false, 10, 2);
+}
+
+TEST_F(tls, mutliproc_sendpage_even)
+{
+	test_mutliproc(_metadata, self, true, 6, 6);
+}
+
+TEST_F(tls, mutliproc_sendpage_readers)
+{
+	test_mutliproc(_metadata, self, true, 4, 12);
+}
+
+TEST_F(tls, mutliproc_sendpage_writers)
+{
+	test_mutliproc(_metadata, self, true, 10, 2);
+}
+
 TEST_F(tls, control_msg)
 {
 	if (self->notls)


