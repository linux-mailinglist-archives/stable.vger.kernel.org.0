Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D624F510
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgHXIoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729113AbgHXIoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:44:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F7A720FC3;
        Mon, 24 Aug 2020 08:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258649;
        bh=isQXeN4Kjqa46COgWlJ4jwfTuzmKFsO5k3hpGO/mHW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPFdNtP5eUCDYu3gKaKXeidatLt8liruT+BHwHhk+68QqgdRE9Yw/Y26dLupx0FEW
         xZE0OpnQ+wbO8G911PaCQ65/E5qT8Q8UMwpp3KbH1xEW26OP+YeR9ckIsIFz6vK/Yp
         gnijQ3XX2d1+i+D7PBoh6+TEfrD/fSgIvKks8DF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.7 121/124] efi/libstub: Stop parsing arguments at "--"
Date:   Mon, 24 Aug 2020 10:30:55 +0200
Message-Id: <20200824082415.357813730@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arvind Sankar <nivedita@alum.mit.edu>

commit 1fd9717d75df68e3c3509b8e7b1138ca63472f88 upstream.

Arguments after "--" are arguments for init, not for the kernel.

Cc: <stable@vger.kernel.org>
Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Link: https://lore.kernel.org/r/20200725155916.1376773-1-nivedita@alum.mit.edu
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/libstub/efi-stub-helper.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -87,6 +87,8 @@ efi_status_t efi_parse_options(char cons
 		char *param, *val;
 
 		str = next_arg(str, &param, &val);
+		if (!val && !strcmp(param, "--"))
+			break;
 
 		if (!strcmp(param, "nokaslr")) {
 			efi_nokaslr = true;


