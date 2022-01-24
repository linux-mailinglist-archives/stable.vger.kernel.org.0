Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1B3498B7F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346065AbiAXTOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:14:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344587AbiAXTLx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:11:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A09612C5;
        Mon, 24 Jan 2022 19:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D6C340E5;
        Mon, 24 Jan 2022 19:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051511;
        bh=4vD56yFlgUBC5atksTz50D4Z2EyBrU/6DhqxbVI8tNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBqcQDqk9bjePlFPGjw0Sd+Eh7ro2pT/fH0FIfHt+lA0lCCJv4/em2dmFy6pr9S/E
         5saap948RUUWYBfyosQpk8IWcbBkNhasiScIL3qQ1ARS7i10rRWgywFTMp9ODMfOdT
         QLmlin/m2b8Jd0mu3FNHX8ZxB094HHz6CEO7ZGCE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Frank Rowand <frank.rowand@sony.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 4.14 178/186] scripts/dtc: dtx_diff: remove broken example from help text
Date:   Mon, 24 Jan 2022 19:44:13 +0100
Message-Id: <20220124183942.837047790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

commit d8adf5b92a9d2205620874d498c39923ecea8749 upstream.

dtx_diff suggests to use <(...) syntax to pipe two inputs into it, but
this has never worked: The /proc/self/fds/... paths passed by the shell
will fail the `[ -f "${dtx}" ] && [ -r "${dtx}" ]` check in compile_to_dts,
but even with this check removed, the function cannot work: hexdump will
eat up the DTB magic, making the subsequent dtc call fail, as a pipe
cannot be rewound.

Simply remove this broken example, as there is already an alternative one
that works fine.

Fixes: 10eadc253ddf ("dtc: create tool to diff device trees")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Frank Rowand <frank.rowand@sony.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220113081918.10387-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/dtc/dtx_diff |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/scripts/dtc/dtx_diff
+++ b/scripts/dtc/dtx_diff
@@ -56,12 +56,8 @@ Otherwise DTx is treated as a dts source
    or '/include/' to be processed.
 
    If DTx_1 and DTx_2 are in different architectures, then this script
-   may not work since \${ARCH} is part of the include path.  Two possible
-   workarounds:
-
-      `basename $0` \\
-          <(ARCH=arch_of_dtx_1 `basename $0` DTx_1) \\
-          <(ARCH=arch_of_dtx_2 `basename $0` DTx_2)
+   may not work since \${ARCH} is part of the include path.  The following
+   workaround can be used:
 
       `basename $0` ARCH=arch_of_dtx_1 DTx_1 >tmp_dtx_1.dts
       `basename $0` ARCH=arch_of_dtx_2 DTx_2 >tmp_dtx_2.dts


