Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9293C1FBAE8
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbgFPPlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731513AbgFPPlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:41:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AF121475;
        Tue, 16 Jun 2020 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322105;
        bh=PXQbYePEv5IhWEvTGJrooq3Lpy51SLgKHXT4N5t/O6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryPo9ou737BGrLqpiLI8UaWvcCc+p8Dc5hzaUy92Qx76dQaBYAmOKEYsI+vUtqKAc
         bp8sSrUXNn1d6wr+sWSiTjPOv2IbaBVvyRSYKUDNf2XjRdACQhl97h5+6gqcq9kfyM
         NIJnu7c8JdKOdUaZRDT0RgVuetnUMbJPNsQipxiQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 112/134] selftests/ftrace: Return unsupported if no error_log file
Date:   Tue, 16 Jun 2020 17:34:56 +0200
Message-Id: <20200616153106.153416320@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

commit 619ee76f5c9f6a1d601d1a056a454d62bf676ae4 upstream.

Check whether error_log file exists in tracing/error_log testcase
and return UNSUPPORTED if no error_log file.

This can happen if we run the ftracetest on the older stable
kernel.

Fixes: 4eab1cc461a6 ("selftests/ftrace: Add tracing/error_log testcase")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/ftrace/test.d/ftrace/tracing-error-log.tc |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/ftrace/test.d/ftrace/tracing-error-log.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/tracing-error-log.tc
@@ -14,6 +14,8 @@ if [ ! -f set_event ]; then
     exit_unsupported
 fi
 
+[ -f error_log ] || exit_unsupported
+
 ftrace_errlog_check 'event filter parse error' '((sig >= 10 && sig < 15) || dsig ^== 17) && comm != bash' 'events/signal/signal_generate/filter'
 
 exit 0


