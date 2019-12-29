Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67CB512C898
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbfL2R40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:56:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733064AbfL2R4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:56:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20DC8222C3;
        Sun, 29 Dec 2019 17:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642184;
        bh=hrFbxjNhvsrrvY+oqXEKDGCsS2EywNEgduk9cGEsG8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hx68a1LIJlTCYXWoek7YHUelWYsa6DQROmxeXu9BtHwOKxYMiACKl7NwDqtKBdOs
         cBBPAuOPU2MgragYSoedXbeDBxPCnRY5/r7qiJWSwwDzv3q5vPa1Lt2LtabCf++mNx
         yEvpokpkm4JYV2Y7RyoT2IgFEQ4sNFkOPqIm9brQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 324/434] selftests, bpf: Fix test_tc_tunnel hanging
Date:   Sun, 29 Dec 2019 18:26:17 +0100
Message-Id: <20191229172723.491154593@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 3b054b7133b4ad93671c82e8d6185258e3f1a7a5 ]

When run_kselftests.sh is run, it hangs after test_tc_tunnel.sh. The reason
is test_tc_tunnel.sh ensures the server ('nc -l') is run all the time,
starting it again every time it is expected to terminate. The exception is
the final client_connect: the server is not started anymore, which ensures
no process is kept running after the test is finished.

For a sit test, though, the script is terminated prematurely without the
final client_connect and the 'nc' process keeps running. This in turn causes
the run_one function in kselftest/runner.sh to hang forever, waiting for the
runaway process to finish.

Ensure a remaining server is terminated on cleanup.

Fixes: f6ad6accaa99 ("selftests/bpf: expand test_tc_tunnel with SIT encap")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/bpf/60919291657a9ee89c708d8aababc28ebe1420be.1573821780.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tc_tunnel.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh b/tools/testing/selftests/bpf/test_tc_tunnel.sh
index ff0d31d38061..7c76b841b17b 100755
--- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
+++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
@@ -62,6 +62,10 @@ cleanup() {
 	if [[ -f "${infile}" ]]; then
 		rm "${infile}"
 	fi
+
+	if [[ -n $server_pid ]]; then
+		kill $server_pid 2> /dev/null
+	fi
 }
 
 server_listen() {
@@ -77,6 +81,7 @@ client_connect() {
 
 verify_data() {
 	wait "${server_pid}"
+	server_pid=
 	# sha1sum returns two fields [sha1] [filepath]
 	# convert to bash array and access first elem
 	insum=($(sha1sum ${infile}))
-- 
2.20.1



