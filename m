Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3CD480061
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbhL0Ppx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:45:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43358 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbhL0Po3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:44:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B8836112A;
        Mon, 27 Dec 2021 15:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FEAC36AEA;
        Mon, 27 Dec 2021 15:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619867;
        bh=Fo/Ywu8F/a+GU+VCJZaUijx4EfbModFwVrgE5okpuZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/lvczuzJopoVY0nD+5AiXKBtXCw1kL6y2AEgNSmSmCKo26CFZdLH3+HDBVtcMBtk
         2Q2AE3OLpcCTipD+GdAJIvnTvvB5b+OoisnjKezPDdDSX4AVZPC9RydULIxv9/RQXu
         5hudLW0V5ebAop94K5YhU5i+JubPDHTaa1+kGla8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 098/128] ksmbd: fix error code in ndr_read_int32()
Date:   Mon, 27 Dec 2021 16:31:13 +0100
Message-Id: <20211227151334.796091388@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ef399469d9ceb9f2171cdd79863f9434b9fa3edc upstream.

This is a failure path and it should return -EINVAL instead of success.
Otherwise it could result in the caller using uninitialized memory.

Fixes: 303fff2b8c77 ("ksmbd: add validation for ndr read/write functions")
Cc: stable@vger.kernel.org # v5.15
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ndr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -148,7 +148,7 @@ static int ndr_read_int16(struct ndr *n,
 static int ndr_read_int32(struct ndr *n, __u32 *value)
 {
 	if (n->offset + sizeof(__u32) > n->length)
-		return 0;
+		return -EINVAL;
 
 	if (value)
 		*value = le32_to_cpu(*(__le32 *)ndr_get_field(n));


