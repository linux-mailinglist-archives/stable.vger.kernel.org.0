Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 895E6236CA
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732764AbfETMQL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfETMQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:16:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD8BE20815;
        Mon, 20 May 2019 12:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354570;
        bh=R7+OcQ0pRtTFgra2O4wzWliBW/uQmdF2ZzODnmYQO8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEAsFLF1woPWHhBlaj2tYk9FW7CUCe/527uPLkekxoOUTyyYXglwmHdf7+FCcW+Eg
         N89qJ9MxYR4ckf8AgyhNrUmkQ+dI3Z2vQPT+3gm8YaOneA/GMJUypDxNV+Ux85c3Ia
         36HxPnhtDstL4TJsKMeLNXOdjONhB/B2JKjmZvJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 4.9 10/44] arm64: Clear OSDLR_EL1 on CPU boot
Date:   Mon, 20 May 2019 14:13:59 +0200
Message-Id: <20190520115232.246013965@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>

commit 6fda41bf12615ee7c3ddac88155099b1a8cf8d00 upstream.

Some firmwares may reboot CPUs with OS Double Lock set. Make sure that
it is unlocked, in order to use debug exceptions.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/debug-monitors.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -132,6 +132,7 @@ NOKPROBE_SYMBOL(disable_debug_monitors);
  */
 static int clear_os_lock(unsigned int cpu)
 {
+	write_sysreg(0, osdlr_el1);
 	write_sysreg(0, oslar_el1);
 	isb();
 	return 0;


