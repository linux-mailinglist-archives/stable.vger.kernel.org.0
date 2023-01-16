Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B4D66CC3C
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbjAPRXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbjAPRWo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D1F34C1A;
        Mon, 16 Jan 2023 09:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54134B8108E;
        Mon, 16 Jan 2023 17:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A66C433F0;
        Mon, 16 Jan 2023 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888446;
        bh=JN7BAhi05lA95z4XwJ24gNQ7l0Zg5HPuQNnc4W+KX58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jywSVsZc2pvRwBNd9UrHuDujYYBdVtztaa+fVdCBbxh+9PkpmyP0QIFaj65+2lKU7
         L7JUhG5qlL59BDAU83vMsn07OYq9b3ag4ksIkecxvSRe1Y3jFGOeLg8QKC8xVEP2SP
         Kpw82nLycbLY8s6ifegQGaeWPacqODNIfk1CRexc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Hutchings <ben@decadent.org.uk>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 4.14 001/338] libtraceevent: Fix build with binutils 2.35
Date:   Mon, 16 Jan 2023 16:47:54 +0100
Message-Id: <20230116154820.749600609@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

From: Ben Hutchings <ben@decadent.org.uk>

commit 39efdd94e314336f4acbac4c07e0f37bdc3bef71 upstream.

In binutils 2.35, 'nm -D' changed to show symbol versions along with
symbol names, with the usual @@ separator.  When generating
libtraceevent-dynamic-list we need just the names, so strip off the
version suffix if present.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Salvatore Bonaccorso <carnil@debian.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/traceevent/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -263,7 +263,7 @@ define do_generate_dynamic_list_file
 	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
 	if [ "$$symbol_type" = "U W" ];then				\
 		(echo '{';						\
-		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
+		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
 		echo '};';						\
 		) > $2;							\
 	else								\


