Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5852EEEAB
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389698AbfKDWQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388147AbfKDWD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:03:59 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42760205C9;
        Mon,  4 Nov 2019 22:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905038;
        bh=FcvIkPlZoo1KYgkGZrbwj5COfkWLmbCCRLPv1vLgQsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U21hsfY+7/ObiK5OyBSpzY7PTTe7MFstq5s5WiL203p6DhXgN5FeulPqKuOZWF0E5
         rXnabYficoMny9PaLdcDXvwm/Qo65BhknKWbKakTmcO+7B7U4msKfun7X65NrMwuKM
         2fUAlscjqeFsSim/uXaL4oVwTwDHplVFr422v9j4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yihui Zeng <yzeng56@asu.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 4.19 127/149] s390/cmm: fix information leak in cmm_timeout_handler()
Date:   Mon,  4 Nov 2019 22:45:20 +0100
Message-Id: <20191104212145.131774179@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yihui ZENG <yzeng56@asu.edu>

commit b8e51a6a9db94bc1fb18ae831b3dab106b5a4b5f upstream.

The problem is that we were putting the NUL terminator too far:

	buf[sizeof(buf) - 1] = '\0';

If the user input isn't NUL terminated and they haven't initialized the
whole buffer then it leads to an info leak.  The NUL terminator should
be:

	buf[len - 1] = '\0';

Signed-off-by: Yihui Zeng <yzeng56@asu.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[heiko.carstens@de.ibm.com: keep semantics of how *lenp and *ppos are handled]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/mm/cmm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -298,16 +298,16 @@ static int cmm_timeout_handler(struct ct
 	}
 
 	if (write) {
-		len = *lenp;
-		if (copy_from_user(buf, buffer,
-				   len > sizeof(buf) ? sizeof(buf) : len))
+		len = min(*lenp, sizeof(buf));
+		if (copy_from_user(buf, buffer, len))
 			return -EFAULT;
-		buf[sizeof(buf) - 1] = '\0';
+		buf[len - 1] = '\0';
 		cmm_skip_blanks(buf, &p);
 		nr = simple_strtoul(p, &p, 0);
 		cmm_skip_blanks(p, &p);
 		seconds = simple_strtoul(p, &p, 0);
 		cmm_set_timeout(nr, seconds);
+		*ppos += *lenp;
 	} else {
 		len = sprintf(buf, "%ld %ld\n",
 			      cmm_timeout_pages, cmm_timeout_seconds);
@@ -315,9 +315,9 @@ static int cmm_timeout_handler(struct ct
 			len = *lenp;
 		if (copy_to_user(buffer, buf, len))
 			return -EFAULT;
+		*lenp = len;
+		*ppos += len;
 	}
-	*lenp = len;
-	*ppos += len;
 	return 0;
 }
 


