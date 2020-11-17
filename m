Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B19E2B628B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgKQN3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:29:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgKQN3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:29:30 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD2521534;
        Tue, 17 Nov 2020 13:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619770;
        bh=lGTBwaOLzltDInUOiWY9XHnOqmHWlpFXn63vO0PF/mo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fwUr4SPWn4ekJD+MuVMYCvzxoWwE94cbH+B2agZLnBQfiwYPO/MGiAE4cBB/kua5g
         qkfmrJF6arsvGfepWhZNMAymbMRm1+4+1totS5UGn+zuKoNCVl4Of1psRIygqtSTwU
         8U1xqVpfquPJ57TfTJIc1K4AdPHykzuvdxVEaUTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Boris Protopopov <pboris@amazon.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.4 151/151] Convert trailing spaces and periods in path components
Date:   Tue, 17 Nov 2020 14:06:21 +0100
Message-Id: <20201117122128.778273044@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boris Protopopov <pboris@amazon.com>

commit 57c176074057531b249cf522d90c22313fa74b0b upstream.

When converting trailing spaces and periods in paths, do so
for every component of the path, not just the last component.
If the conversion is not done for every path component, then
subsequent operations in directories with trailing spaces or
periods (e.g. create(), mkdir()) will fail with ENOENT. This
is because on the server, the directory will have a special
symbol in its name, and the client needs to provide the same.

Signed-off-by: Boris Protopopov <pboris@amazon.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifs_unicode.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const
 		else if (map_chars == SFM_MAP_UNI_RSVD) {
 			bool end_of_string;
 
-			if (i == srclen - 1)
+			/**
+			 * Remap spaces and periods found at the end of every
+			 * component of the path. The special cases of '.' and
+			 * '..' do not need to be dealt with explicitly because
+			 * they are addressed in namei.c:link_path_walk().
+			 **/
+			if ((i == srclen - 1) || (source[i+1] == '\\'))
 				end_of_string = true;
 			else
 				end_of_string = false;


