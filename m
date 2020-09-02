Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728A825AC93
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 16:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbgIBOJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 10:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgIBOFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Sep 2020 10:05:36 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266FAC061245
        for <stable@vger.kernel.org>; Wed,  2 Sep 2020 07:05:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id ay8so5033193edb.8
        for <stable@vger.kernel.org>; Wed, 02 Sep 2020 07:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dgidSd24Zz8hlurLEhIlaHA9MiqL30gKJkyfF1ZIoik=;
        b=StgYX6WEyNguJD78wKYoIc6Bzw+h1h27+/lHbg8EEcbJLQWRdtTLBBo2MvJLB0JA0t
         2caDPPZvN2//8XqW34Pr9rzgXIq2uZf4ppROnvkJ/9k0I/WQUEfjInuFmYgrPh8h4QGu
         /qGTVuI7qoYn8+VkcBDVd4cR5QATBjsET5R/+G6lI4HFHqjjSFwWHf0uTBBazCX+5H1P
         iqOv/FiQAUevHmNdZuiGuiualTDluCi9wv2rGAF3vs8tAlUzL/sMiay2Uw2AH0dzClta
         f264i5ORJ8UI/S6kL9tKAZE8KikP0FsnYFeEd4Jze8N6N+fdp5ucJic2l80+hiXHC8LT
         HuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dgidSd24Zz8hlurLEhIlaHA9MiqL30gKJkyfF1ZIoik=;
        b=MXxnP4vToJYbtyoahmq4phLab/BtERqcP3UUw/3C+ymo5IxKlFV6mjkGNe6WkmhkeN
         S23QrYdvzgnSF5jLJVYDCWl48/TUwh01GcG6j1w7VqR0vPYuczx1RmAwR/7NrUcvcX7/
         zSqRn48rEM3NE+pLtaDGcBUe7z2SXpPjkkwsYOZrKiZVKLj68JskCXXeknfWKYsryIzV
         pb6o41JGWZUbjuRT8duFybGJj45olw4rQYGN0PuiVErAKDBYIrNvOGLaqbN8qhK6mFQQ
         8JwHr1mLBV1UU1SgJ5OaX8Rm/zfxdNzBeiSlQ6Jg+qqX/tGUi2scnlESStiryDx2VCcb
         AURg==
X-Gm-Message-State: AOAM532m+42ODsTWwOZFI3AZb6A27Ig4524Nxzdnd8Yn383DFJy8RJcP
        c1aNI0uBqdSJi4rWmp2ckbsOpoqbYN34NmdP
X-Google-Smtp-Source: ABdhPJztMFzXGv+nvq1KeuMgIijPAhD16TI+0vCZRXdeRoRtJ+KR5eRiK0oQrCc5mxuqp+TRU0lkYg==
X-Received: by 2002:a05:6402:489:: with SMTP id k9mr192758edv.287.1599055534860;
        Wed, 02 Sep 2020 07:05:34 -0700 (PDT)
Received: from tim.froidcoeur.net (ptr-7tznw14oqa3w7cibjsc.18120a2.ip6.access.telenet.be. [2a02:1811:50e:f0f0:8cba:3abe:17e1:aaec])
        by smtp.gmail.com with ESMTPSA id os15sm4354775ejb.61.2020.09.02.07.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 07:05:34 -0700 (PDT)
From:   Tim Froidcoeur <tim.froidcoeur@tessares.net>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        matthieu.baerts@tessares.net, davem@davemloft.net,
        Tim Froidcoeur <tim.froidcoeur@tessares.net>
Subject: [PATCH 4.4 0/2] net: initialize fastreuse on inet_inherit_port
Date:   Wed,  2 Sep 2020 16:05:11 +0200
Message-Id: <20200902140513.866712-1-tim.froidcoeur@tessares.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix for TPROXY initialization of fastreuse flag.
upstream patch was backported by Greg K-H to 4.14 and higher stable version.

see also https://lore.kernel.org/stable/20200818072007.GA9254@kroah.com

code in inet_csk_get_port for 4.4 (and 4.9) is different from
the upstream version, so these backports had to be adapted (a bit)

Tim Froidcoeur (2):
  net: refactor bind_bucket fastreuse into helper
  net: initialize fastreuse on inet_inherit_port

 include/net/inet_connection_sock.h |  4 +++
 net/ipv4/inet_connection_sock.c    | 46 ++++++++++++++++++------------
 net/ipv4/inet_hashtables.c         |  1 +
 3 files changed, 33 insertions(+), 18 deletions(-)

--
2.25.1
