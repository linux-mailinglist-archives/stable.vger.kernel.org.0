Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28EB66C468
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbjAPPyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjAPPyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F34C1D912
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6F2FACE122F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AE7C433EF;
        Mon, 16 Jan 2023 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884471;
        bh=WW0a0qdBtJsJ9yejOmW09xrzyZE7t48zbRGXtsTamR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1jyapVe9Il3iTxWKg4+xlQc5QfvSZfWOZ0P7i0SZ5va6CvY49ThKsedf4LJybvdZi
         3Y139ArgMSoonsubJIYB8Q/Jvjm29A64XCUq99fnWsY5Mgnr+nVNDFlz5x+vV3zlsG
         hu9WYcqm8engL7QfxuWS90kj8vWObuzgyMXFDcxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.1 019/183] s390/kexec: fix ipl report address for kdump
Date:   Mon, 16 Jan 2023 16:49:02 +0100
Message-Id: <20230116154804.216791566@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Alexander Egorenkov <egorenar@linux.ibm.com>

commit c2337a40e04dde1692b5b0a46ecc59f89aaba8a1 upstream.

This commit addresses the following erroneous situation with file-based
kdump executed on a system with a valid IPL report.

On s390, a kdump kernel, its initrd and IPL report if present are loaded
into a special and reserved on boot memory region - crashkernel. When
a system crashes and kdump was activated before, the purgatory code
is entered first which swaps the crashkernel and [0 - crashkernel size]
memory regions. Only after that the kdump kernel is entered. For this
reason, the pointer to an IPL report in lowcore must point to the IPL report
after the swap and not to the address of the IPL report that was located in
crashkernel memory region before the swap. Failing to do so, makes the
kdump's decompressor try to read memory from the crashkernel memory region
which already contains the production's kernel memory.

The situation described above caused spontaneous kdump failures/hangs
on systems where the Secure IPL is activated because on such systems
an IPL report is always present. In that case kdump's decompressor tried
to parse an IPL report which frequently lead to illegal memory accesses
because an IPL report contains addresses to various data.

Cc: <stable@vger.kernel.org>
Fixes: 99feaa717e55 ("s390/kexec_file: Create ipl report and pass to next kernel")
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/machine_kexec_file.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/machine_kexec_file.c
+++ b/arch/s390/kernel/machine_kexec_file.c
@@ -187,8 +187,6 @@ static int kexec_file_add_ipl_report(str
 
 	data->memsz = ALIGN(data->memsz, PAGE_SIZE);
 	buf.mem = data->memsz;
-	if (image->type == KEXEC_TYPE_CRASH)
-		buf.mem += crashk_res.start;
 
 	ptr = (void *)ipl_cert_list_addr;
 	end = ptr + ipl_cert_list_size;
@@ -225,6 +223,9 @@ static int kexec_file_add_ipl_report(str
 		data->kernel_buf + offsetof(struct lowcore, ipl_parmblock_ptr);
 	*lc_ipl_parmblock_ptr = (__u32)buf.mem;
 
+	if (image->type == KEXEC_TYPE_CRASH)
+		buf.mem += crashk_res.start;
+
 	ret = kexec_add_buffer(&buf);
 out:
 	return ret;


