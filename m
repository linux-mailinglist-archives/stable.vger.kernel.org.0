Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77E22662F
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbgGTQBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730708AbgGTQBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:01:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3D9520684;
        Mon, 20 Jul 2020 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260860;
        bh=ILCPdK/AVTi25LE3EFnGuEvILO42AxxfXTJ0iySkEDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1EEpasNFYLa05HIu1o3dQr00LcKaEyUsDPge8t8zspFW730hV+xiKbK8AQ16fEbc
         OKefDJk0Fe/MCKzTLboX/dddAgNilCHIyCkzuoYrODl5xe5jcXKsw3NcX+nQfpkqgy
         72Mlh/Xns4yZLx8XLTiQ3JrVuu9Lgba21PO7yi0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Salvatore <mike.salvatore@canonical.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.4 122/215] apparmor: ensure that dfa state tables have entries
Date:   Mon, 20 Jul 2020 17:36:44 +0200
Message-Id: <20200720152826.004383435@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit c27c6bd2c4d6b6bb779f9b722d5607993e1d5e5c upstream.

Currently it is possible to specify a state machine table with 0 length,
this is not valid as optional tables are specified by not defining
the table as present. Further this allows by-passing the base tables
range check against the next/check tables.

Fixes: d901d6a298dc ("apparmor: dfa split verification of table headers")
Reported-by: Mike Salvatore <mike.salvatore@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/match.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/security/apparmor/match.c
+++ b/security/apparmor/match.c
@@ -97,6 +97,9 @@ static struct table_header *unpack_table
 	      th.td_flags == YYTD_DATA8))
 		goto out;
 
+	/* if we have a table it must have some entries */
+	if (th.td_lolen == 0)
+		goto out;
 	tsize = table_size(th.td_lolen, th.td_flags);
 	if (bsize < tsize)
 		goto out;
@@ -198,6 +201,8 @@ static int verify_dfa(struct aa_dfa *dfa
 
 	state_count = dfa->tables[YYTD_ID_BASE]->td_lolen;
 	trans_count = dfa->tables[YYTD_ID_NXT]->td_lolen;
+	if (state_count == 0)
+		goto out;
 	for (i = 0; i < state_count; i++) {
 		if (!(BASE_TABLE(dfa)[i] & MATCH_FLAG_DIFF_ENCODE) &&
 		    (DEFAULT_TABLE(dfa)[i] >= state_count))


