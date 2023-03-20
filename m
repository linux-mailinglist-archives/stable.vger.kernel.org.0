Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3026C180D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbjCTPTv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjCTPTc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:19:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80BC6595
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:13:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C113B80EC5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4E53C433D2;
        Mon, 20 Mar 2023 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325238;
        bh=S6AoOAsIo8yAveuwlr6QRe1L5MwF2dsJT7Ztt/10cDw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+Htno46A9JUsukPOXmqNtd9snEQckKy915jGvcHFQtucssRgUinA8ZUPXO1dthnC
         sDLpQPbqA7aI7P4+qX0TEYdc/2bkL6dCLB1w8ZCdLMW5mVS5v+Xvic2Om+RgZnYkRv
         yBnyTAsbTbuPOVklbhBmwncyU8hTise+dd/cK1NQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sung-hun Kim <sfoon.kim@samsung.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 081/115] tracing: Make splice_read available again
Date:   Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145452.819421221@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung-hun Kim <sfoon.kim@samsung.com>

commit e400be674a1a40e9dcb2e95f84d6c1fd2d88f31d upstream.

Since the commit 36e2c7421f02 ("fs: don't allow splice read/write
without explicit ops") is applied to the kernel, splice() and
sendfile() calls on the trace file (/sys/kernel/debug/tracing
/trace) return EINVAL.

This patch restores these system calls by initializing splice_read
in file_operations of the trace file. This patch only enables such
functionalities for the read case.

Link: https://lore.kernel.org/linux-trace-kernel/20230314013707.28814-1-sfoon.kim@samsung.com

Cc: stable@vger.kernel.org
Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Signed-off-by: Sung-hun Kim <sfoon.kim@samsung.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5093,6 +5093,8 @@ loff_t tracing_lseek(struct file *file,
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,


