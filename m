Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDA066C5B4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232304AbjAPQJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbjAPQIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:08:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16371E1F0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:05:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EABA60C1B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D2AC4339B;
        Mon, 16 Jan 2023 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885157;
        bh=XalcQgvmaKEiJxgess2rg5blO9B8KGoVgxoeRmUeb4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Q4q2uOqDCc9W14hdkd2avPeBjPud8DcJDRw6AOkJfD4CZlc4qx4nDroV4IjeQEsw
         iLnuiPXCm6Fp9aCYYmQcel0Bk05M9Acqk4zl51kyWc2hwSA7jhrl2Pz8LB9RlaBMMH
         QZQ4IKJLV5xow0F8Lu5R4YLaiBbPD0W6l2mvn+pA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 10/64] s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()
Date:   Mon, 16 Jan 2023 16:51:17 +0100
Message-Id: <20230116154744.015209980@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Heiko Carstens <hca@linux.ibm.com>

commit e3f360db08d55a14112bd27454e616a24296a8b0 upstream.

Make sure that *ptr__ within arch_this_cpu_to_op_simple() is only
dereferenced once by using READ_ONCE(). Otherwise the compiler could
generate incorrect code.

Cc: <stable@vger.kernel.org>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -31,7 +31,7 @@
 	pcp_op_T__ *ptr__;						\
 	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
-	prev__ = *ptr__;						\
+	prev__ = READ_ONCE(*ptr__);					\
 	do {								\
 		old__ = prev__;						\
 		new__ = old__ op (val);					\


