Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4062413FF68
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388196AbgAPX0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388570AbgAPX0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3A6820684;
        Thu, 16 Jan 2020 23:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217173;
        bh=rZxzFmoa86ylUJe4TS+EB8Wyx7/hluposH2EB+Imi8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBSmewAdqMyX1J+/POXglJhtlNR34YfXIqxxGIx498Fa3z9p/7U+JDy+2Ez0jMgfQ
         zkwtUWofElE1phB9HyYQKBsHI/D7drJZ6tkOblztblykS2H7XaLHj189AM2t7PcrzT
         tLrtDAzKHxqjiyAhQLQ/c1hzNxf4IP5Yg1pHx88c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 177/203] NFSD fixing possible null pointer derefering in copy offload
Date:   Fri, 17 Jan 2020 00:18:14 +0100
Message-Id: <20200116231759.922172938@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

commit 18f428d4e2f7eff162d80b2b21689496c4e82afd upstream.

Static checker revealed possible error path leading to possible
NULL pointer dereferencing.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: e0639dc5805a: ("NFSD introduce async copy feature")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1298,7 +1298,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struc
 out:
 	return status;
 out_err:
-	cleanup_async_copy(async_copy);
+	if (async_copy)
+		cleanup_async_copy(async_copy);
 	goto out;
 }
 


