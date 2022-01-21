Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03527496860
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 00:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiAUXyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 18:54:40 -0500
Received: from mail-pj1-f52.google.com ([209.85.216.52]:44660 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiAUXyj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 18:54:39 -0500
Received: by mail-pj1-f52.google.com with SMTP id v11-20020a17090a520b00b001b512482f36so7516331pjh.3;
        Fri, 21 Jan 2022 15:54:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q/aXQZ68RTanxH11FEnoBmUV0EdbBxwAc8bXGd6VfMY=;
        b=UgHTYKUOTDJNU+5WUaTO3dq+P6pycl4s03eXaDEHY9OhXadIHAXtAUb4eg68NU3CyP
         iqN3C6ybjlm85mCkFXuzlS+CgWkpWpga0u9ZPNX4RMZ5o26JAR6y1cA15JQS1sj8MKN5
         LSMYlyoXRpS5N5A1F8HUUGj4o1mnAviRnzUlbkSFmqS4eqTAdGO3/3TTw4ETfhQekC0t
         1pRUZLQ0/MGPeurMJftVInrHt2kwoNa2JXueY0M0jNE4sNdkolGrhf0eSSKgHDiOibRP
         fId6IdhWjvkwTmQz1xBOmonmUBT2Qi9xYtwhS/b3BKeIgrHEa2ILadU0O6wtpZuSyMUc
         fIDg==
X-Gm-Message-State: AOAM531an7PX0xv+AOC2o7OL7ZyM5AguYOCsYz4DDhHQFZZxiUnm8L4z
        +eAsYeYwiY7e9O/56wm21oU=
X-Google-Smtp-Source: ABdhPJw80Tz1KGdU3qt/rTOV+vkBXSKS8ZDPhn2iglly7O9Gf+eWCtlGis/F2nML+xfewPJx9ktkPQ==
X-Received: by 2002:a17:902:bd93:b0:149:ba01:e67a with SMTP id q19-20020a170902bd9300b00149ba01e67amr6070680pls.156.1642809279435;
        Fri, 21 Jan 2022 15:54:39 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id 5sm14530082pjf.34.2022.01.21.15.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 15:54:39 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, smfrench@gmail.com,
        linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5.16.y 0/4] ksmbd stable patches for 5.16.y
Date:   Sat, 22 Jan 2022 08:54:23 +0900
Message-Id: <20220121235427.10349-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

These patches include 2 patches to run the recently updated
ksmbd.mountd(3.4.4) and 2 other patches to fix issues to avoid out of
memory issues caused by many outstanding smb2 locks. These are
important patches applied to linux-5.17-rc1, but they cannot be applied
to the stable kernel, so they are sent as separately backported patches.

Namjae Jeon (4):
  ksmbd: add support for smb2 max credit parameter
  ksmbd: move credit charge deduction under processing request
  ksmbd: limits exceeding the maximum allowable outstanding requests
  ksmbd: add reserved room in ipc request/response

 fs/ksmbd/connection.c    |  1 +
 fs/ksmbd/connection.h    |  4 ++--
 fs/ksmbd/ksmbd_netlink.h | 12 +++++++++++-
 fs/ksmbd/smb2misc.c      | 18 ++++++++++++------
 fs/ksmbd/smb2ops.c       | 16 ++++++++++++----
 fs/ksmbd/smb2pdu.c       | 25 +++++++++++++++----------
 fs/ksmbd/smb2pdu.h       |  1 +
 fs/ksmbd/smb_common.h    |  1 +
 fs/ksmbd/transport_ipc.c |  2 ++
 9 files changed, 57 insertions(+), 23 deletions(-)

-- 
2.25.1

