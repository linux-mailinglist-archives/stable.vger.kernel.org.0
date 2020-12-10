Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D7C2D5DB9
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390154AbgLJO2n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:28:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:36422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgLJO2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:28:39 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paulo Alcantara (SUSE)" <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.4 26/39] cifs: fix potential use-after-free in cifs_echo_request()
Date:   Thu, 10 Dec 2020 15:26:37 +0100
Message-Id: <20201210142602.188747692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142600.887734129@linuxfoundation.org>
References: <20201210142600.887734129@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paulo Alcantara <pc@cjr.nz>

commit 212253367dc7b49ed3fc194ce71b0992eacaecf2 upstream.

This patch fixes a potential use-after-free bug in
cifs_echo_request().

For instance,

  thread 1
  --------
  cifs_demultiplex_thread()
    clean_demultiplex_info()
      kfree(server)

  thread 2 (workqueue)
  --------
  apic_timer_interrupt()
    smp_apic_timer_interrupt()
      irq_exit()
        __do_softirq()
          run_timer_softirq()
            call_timer_fn()
	      cifs_echo_request() <- use-after-free in server ptr

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
CC: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/connect.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -783,6 +783,8 @@ static void clean_demultiplex_info(struc
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
+	cancel_delayed_work_sync(&server->echo);
+
 	spin_lock(&GlobalMid_Lock);
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);


