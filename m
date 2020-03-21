Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06BE018DDB7
	for <lists+stable@lfdr.de>; Sat, 21 Mar 2020 03:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgCUCrL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 20 Mar 2020 22:47:11 -0400
Received: from mail-am6eur05olkn2059.outbound.protection.outlook.com ([40.92.91.59]:37472
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726840AbgCUCrK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 22:47:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNTjLty013s8Td+o6PdoUKlWu8Y33c2a0O6Rlc2GxuLtf9xX3tlfinv5UtzENmJ+ik60a9TNWhBnfx4ZCsmUGlFql5gB5BmyCeqE7tHPIE8maHGpbhNtSdTUx1Czozdnk+9KKjmQwB+VRP5E/NpDiivRUJpzmQ2erD5TDfGf71tUVq3VeUez8izBFlOZFeHnmcnoWOKrUEIUsgQOFd8SXL2p9PThLxTXxLqAqGog23ayLXQewffKB+PhRVGsdzC1h9+SbEXwGMcLQy5FWgG8/5J38oJuAat4j9s2tnJOSKMLMngFX4JRwWkxzmE/bmyA8WXO4aBh7jBbOXCYnAdGLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMxz+RuV9RQMUxgG0UAnwQ7e+XVLgekPkpYVpUFheXA=;
 b=BTUOB/kDKAuGJgnIGBVF/H88+AgdugmdNO2fjW3R997zrCNyqocoDrhU8b7nn2e0lCEYU7stApDojpPJuIhyl46CXOQ7IovrS5EI1wuti+M+DTbdHo7I+PT/IyUVtEqPM7Pt5oNUDVwDY46cyLJq3y/PoSD1agVJ8YVN2j0kG53oTX5vb5iZc9bnCa/anTu6TeMOwmowrBPBJ7cE2805jMxZKX1UfHV4FM4mTv2HXa57KFxuEu3fmUF5+V9Iu/h7Oc0eoXyY55YtT3gKxMLP6+mK1wYi/jk1avjf47R099dVeCTRo1bPv0KwmFCV/RzAFi0ikX9DrTfBuGK/IW7L3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR05FT062.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::33) by
 VI1EUR05HT022.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::77)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Sat, 21 Mar
 2020 02:47:04 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.242.53) by
 VI1EUR05FT062.mail.protection.outlook.com (10.233.243.189) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Sat, 21 Mar 2020 02:47:04 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2835.017; Sat, 21 Mar 2020
 02:47:04 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        "jannh@google.com" <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: [PATCH v6 16/16] doc: Update documentation of ->exec_*_mutex
Thread-Topic: [PATCH v6 16/16] doc: Update documentation of ->exec_*_mutex
Thread-Index: AQHV/vVmRRuSYR3ND0imHjEGSGoE8w==
Date:   Sat, 21 Mar 2020 02:47:04 +0000
Message-ID: <3ce46b88-7ed3-2f21-c0ed-8f6055d38ebb@hotmail.de>
References: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
In-Reply-To: <077b63b7-6f5e-aa8e-bf96-a586b481cc46@hotmail.de>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-imapappendstamp: AM6PR03MB5170.eurprd03.prod.outlook.com
 (15.20.2835.016)
x-incomingtopheadermarker: OriginalChecksum:D59A7125C1ECEE8EC38414552399C105A4F8B87DB3BC2846933447E6B527A079;UpperCasedChecksum:E01611456461A8E7B89DB78136D189B18EE3BAEFD2C60D65FA6942FBE887FA2F;SizeAsReceived:8475;Count:46
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [FSjQ7o0dBOcWLZIQbDVvCPMI4Lsxt0vu]
x-ms-publictraffictype: Email
x-incomingheadercount: 46
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 366a69d2-1471-4b70-ba6d-08d7cd4223d8
x-ms-traffictypediagnostic: VI1EUR05HT022:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q34OtT4FVmQK6n7e6GU4FNGkL06IEggWsiG7zRTqKZmX/Baf/5sXo3UPD5hyeKYXdHGV/Pmmfs7u1R/VyKmieckq5Jwgh2brCqmxWvamD7/EcAi9A3HZKbXGO9YKZME83zIji5FZufAEneTII4UvSeqTA7Zio4Fkz06ZDyJl9OG69/MN1kTy07pZrxLj/TLT
x-ms-exchange-antispam-messagedata: mDB3dAqm/a2K6L0KmfdLOaVkB8BPHaNYy4wU0us/yCkizMj3ebSqd7DXb2TCopp+zepvraJQwCtJonNOQIuJjry/qaA105bGyLTKYZqN/4Ak/p2mh0WXx6solgw5jaRgooiijgaH4nXgmqGnTu/U8g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4175CD035CA92C46A2291553CAB5F9B9@sct-15-20-2387-20-msonline-outlook-45755.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 366a69d2-1471-4b70-ba6d-08d7cd4223d8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2020 02:47:04.8066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT022
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This brings the outdated Documentation/security/credentials.rst
back in line with the current implementation, and describes the
purpose of current->signal->exec_update_mutex,
current->signal->exec_guard_mutex and
current->signal->unsafe_execve_in_progress.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
---
 Documentation/security/credentials.rst | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/Documentation/security/credentials.rst b/Documentation/security/credentials.rst
index 282e79f..fe4cd76 100644
--- a/Documentation/security/credentials.rst
+++ b/Documentation/security/credentials.rst
@@ -437,15 +437,30 @@ new set of credentials by calling::
 
 	struct cred *prepare_creds(void);
 
-this locks current->cred_replace_mutex and then allocates and constructs a
-duplicate of the current process's credentials, returning with the mutex still
-held if successful.  It returns NULL if not successful (out of memory).
+this allocates and constructs a duplicate of the current process's credentials.
+It returns NULL if not successful (out of memory).
+
+If called from __do_execve_file, the mutex current->signal->exec_guard_mutex
+is acquired before this function gets called, and usually released after
+the new process mmap and credentials are installed.  However if one of the
+sibling threads are being traced when the execve is invoked, there is no
+guarantee how long it takes to terminate all sibling threads, and therefore
+the variable current->signal->unsafe_execve_in_progress is set, and the
+exec_guard_mutex is released immediately.  Functions that may have effect
+on the credentials of a different thread need to lock the exec_guard_mutex
+and additionally check the unsafe_execve_in_progress status, and fail with
+-EAGAIN if that variable is set.
 
 The mutex prevents ``ptrace()`` from altering the ptrace state of a process
 while security checks on credentials construction and changing is taking place
 as the ptrace state may alter the outcome, particularly in the case of
 ``execve()``.
 
+The mutex current->signal->exec_update_mutex is acquired when only a single
+thread is remaining, and the credentials and the process mmap are actually
+changed.  Functions that only need to access to a consistent state of the
+credentials and the process mmap do only need to aquire this mutex.
+
 The new credentials set should be altered appropriately, and any security
 checks and hooks done.  Both the current and the proposed sets of credentials
 are available for this purpose as current_cred() will return the current set
@@ -466,9 +481,8 @@ by calling::
 
 This will alter various aspects of the credentials and the process, giving the
 LSM a chance to do likewise, then it will use ``rcu_assign_pointer()`` to
-actually commit the new credentials to ``current->cred``, it will release
-``current->cred_replace_mutex`` to allow ``ptrace()`` to take place, and it
-will notify the scheduler and others of the changes.
+actually commit the new credentials to ``current->cred``, and it will notify
+the scheduler and others of the changes.
 
 This function is guaranteed to return 0, so that it can be tail-called at the
 end of such functions as ``sys_setresuid()``.
@@ -486,8 +500,7 @@ invoked::
 
 	void abort_creds(struct cred *new);
 
-This releases the lock on ``current->cred_replace_mutex`` that
-``prepare_creds()`` got and then releases the new credentials.
+This releases the new credentials.
 
 
 A typical credentials alteration function would look something like this::
-- 
1.9.1
