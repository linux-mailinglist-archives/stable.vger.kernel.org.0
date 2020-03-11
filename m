Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72449181186
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 08:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKHNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 03:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726160AbgCKHNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 03:13:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2852208E4;
        Wed, 11 Mar 2020 07:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583910801;
        bh=Wzy6qezHn1X5WuK8uTjNlfWKf37u2KIuR1pwhFrB2do=;
        h=Subject:To:From:Date:From;
        b=Kqb9fuEtMfHhUjdgNEy96CGIAzkGSK2QpyovonlGSuvVd7tQwUwmMlYSpR/Ioit5g
         KTkIO7JS5KBd7mZTPjf4aB1rSm7Qc7PUCKgAskLTHwLcw+IvhSNxtCRthZdGcyOeDM
         R3ASx+2INVSW4tECXav7/93mpLWJokUQgKriWt6Q=
Subject: patch "staging/speakup: fix get_word non-space look-ahead" added to staging-linus
To:     samuel.thibault@ens-lyon.org, aarnaarn2@gmail.com,
        deedra@the-brannons.com, greg@gregn.net,
        gregkh@linuxfoundation.org, janina@rednote.net, kirk@reisers.ca,
        michael@michaels.world, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 11 Mar 2020 08:13:18 +0100
Message-ID: <1583910798147161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging/speakup: fix get_word non-space look-ahead

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9d32c0cde4e2d1343dfb88a67b2ec6397705b32b Mon Sep 17 00:00:00 2001
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Fri, 6 Mar 2020 01:30:47 +0100
Subject: staging/speakup: fix get_word non-space look-ahead

get_char was erroneously given the address of the pointer to the text
instead of the address of the text, thus leading to random crashes when
the user requests speaking a word while the current position is on a space
character and say_word_ctl is not enabled.

Reported-on: https://github.com/bytefire/speakup/issues/1
Reported-by: Kirk Reiser <kirk@reisers.ca>
Reported-by: Janina Sajka <janina@rednote.net>
Reported-by: Alexandr Epaneshnikov <aarnaarn2@gmail.com>
Reported-by: Gregory Nowak <greg@gregn.net>
Reported-by: deedra waters <deedra@the-brannons.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Tested-by: Alexandr Epaneshnikov <aarnaarn2@gmail.com>
Tested-by: Gregory Nowak <greg@gregn.net>
Tested-by: Michael Taboada <michael@michaels.world>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200306003047.thijtmqrnayd3dmw@function
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/speakup/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/main.c b/drivers/staging/speakup/main.c
index 488f2539aa9a..81ecfd1a200d 100644
--- a/drivers/staging/speakup/main.c
+++ b/drivers/staging/speakup/main.c
@@ -561,7 +561,7 @@ static u_long get_word(struct vc_data *vc)
 		return 0;
 	} else if (tmpx < vc->vc_cols - 2 &&
 		   (ch == SPACE || ch == 0 || (ch < 0x100 && IS_WDLM(ch))) &&
-		   get_char(vc, (u_short *)&tmp_pos + 1, &temp) > SPACE) {
+		   get_char(vc, (u_short *)tmp_pos + 1, &temp) > SPACE) {
 		tmp_pos += 2;
 		tmpx++;
 	} else {
-- 
2.25.1


