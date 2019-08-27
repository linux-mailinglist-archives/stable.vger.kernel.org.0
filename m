Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A22A9DFD6
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 09:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730911AbfH0H6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730474AbfH0H54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:57:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECD80206BA;
        Tue, 27 Aug 2019 07:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892675;
        bh=Pox7UGSVc3exntObymrJZRHxDv/1qDz0hdp3/iMqotU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NiBZs+sut8MZK52lgRo/o4CDRX6UOYlh+G5xxEiP9C7lWGcBc6EL4ZyGvICx1uMSD
         muU6K58JierscaDiW9hgXRzHOhP/ZL9NgMZYpF8SlkVeD/7Ab21Hftc07j+cTf+wBg
         RIiXmKj65JU/sGJ9Xmf6N9a3BFVUg9ksg3QsPcDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil MacLeod <neil@nmacleod.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 4.19 74/98] x86/boot: Fix boot regression caused by bootparam sanitizing
Date:   Tue, 27 Aug 2019 09:50:53 +0200
Message-Id: <20190827072722.081796585@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

commit 7846f58fba964af7cb8cf77d4d13c33254725211 upstream.

commit a90118c445cc ("x86/boot: Save fields explicitly, zero out everything
else") had two errors:

    * It preserved boot_params.acpi_rsdp_addr, and
    * It failed to preserve boot_params.hdr

Therefore, zero out acpi_rsdp_addr, and preserve hdr.

Fixes: a90118c445cc ("x86/boot: Save fields explicitly, zero out everything else")
Reported-by: Neil MacLeod <neil@nmacleod.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Neil MacLeod <neil@nmacleod.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190821192513.20126-1-jhubbard@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/bootparam_utils.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/include/asm/bootparam_utils.h
+++ b/arch/x86/include/asm/bootparam_utils.h
@@ -71,6 +71,7 @@ static void sanitize_boot_params(struct
 			BOOT_PARAM_PRESERVE(eddbuf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buf_entries),
 			BOOT_PARAM_PRESERVE(edd_mbr_sig_buffer),
+			BOOT_PARAM_PRESERVE(hdr),
 			BOOT_PARAM_PRESERVE(e820_table),
 			BOOT_PARAM_PRESERVE(eddbuf),
 		};


