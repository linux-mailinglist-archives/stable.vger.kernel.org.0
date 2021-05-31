Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE380395DFF
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhEaNwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231691AbhEaNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:50:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E6066162C;
        Mon, 31 May 2021 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467927;
        bh=Bzk3q18Rykvj7pc36KDsfBnTnyDHicERbODMBtkjrJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VC7FE5rYnxoTkAwNPEDi05gwapXsLUNEF5FxL0A8NPUrGBemHJ28EqBn4yXSfZ76x
         l/BqyePg3HEnNMg6ugGziKI/i4N1vOxgiCvGkccdWt5jJxIDwZRsc15K6GLaydw7LN
         s/4NPSMk0UuNhYZ8qpOdEtluB/bsx2JTli/ZfwMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 5.10 053/252] serial: core: fix suspicious security_locked_down() call
Date:   Mon, 31 May 2021 15:11:58 +0200
Message-Id: <20210531130659.786984803@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit 5e722b217ad3cf41f5504db80a68062df82b5242 upstream.

The commit that added this check did so in a very strange way - first
security_locked_down() is called, its value stored into retval, and if
it's nonzero, then an additional check is made for (change_irq ||
change_port), and if this is true, the function returns. However, if
the goto exit branch is not taken, the code keeps the retval value and
continues executing the function. Then, depending on whether
uport->ops->verify_port is set, the retval value may or may not be reset
to zero and eventually the error value from security_locked_down() may
abort the function a few lines below.

I will go out on a limb and assume that this isn't the intended behavior
and that an error value from security_locked_down() was supposed to
abort the function only in case (change_irq || change_port) is true.

Note that security_locked_down() should be called last in any series of
checks, since the SELinux implementation of this hook will do a check
against the policy and generate an audit record in case of denial. If
the operation was to carry on after calling security_locked_down(), then
the SELinux denial record would be bogus.

See commit 59438b46471a ("security,lockdown,selinux: implement SELinux
lockdown") for how SELinux implements this hook.

Fixes: 794edf30ee6c ("lockdown: Lock down TIOCSSERIAL")
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210507115719.140799-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -865,9 +865,11 @@ static int uart_set_info(struct tty_stru
 		goto check_and_exit;
 	}
 
-	retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
-	if (retval && (change_irq || change_port))
-		goto exit;
+	if (change_irq || change_port) {
+		retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
+		if (retval)
+			goto exit;
+	}
 
 	/*
 	 * Ask the low level driver to verify the settings.


