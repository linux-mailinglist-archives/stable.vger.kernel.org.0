Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41CD017AA80
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 17:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgCEQaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 11:30:10 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40181 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEQaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 11:30:10 -0500
Received: by mail-ed1-f65.google.com with SMTP id a13so7522088edu.7
        for <stable@vger.kernel.org>; Thu, 05 Mar 2020 08:30:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d3O4qVPC7P+tM6D12k3RrdjZGaW4VfInZ7uNVih+wmY=;
        b=WWdMnbsfDQiG4oHd1bsCOg69QuV7waSYieotXC8hzYL+al0Q/lWI86vhFEtb/WmOHR
         nCPkCPCDZzkRabSYRvfwhMQfAGdFe8gBNi7OEOi6f1tK4DOOVjLlaxUqDaXfThfXfo7O
         DEpGzMrAPjS3Do54Uww7lJ+fghC28DeS/0D5frpQvUBMfWsS/zUWuOmqAyDY6VYhn5Uj
         5fBNOO31hrH4JcGgIwupgmduX2dJAe/8CusgDPei3A6lplGjV3mjApcIn8xBrsI4HGb3
         t2uNQRK+jgIpUcLDVQ9FBeZmyC+UuygEL8j40SnByIXOjLdQb3sjGQIegrbnrx3qOmoL
         YYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d3O4qVPC7P+tM6D12k3RrdjZGaW4VfInZ7uNVih+wmY=;
        b=qYnktxaofNLq4zDst21lsJ7Z6Sl1yui6tU/95o0XM0FPg908cM/x/ihr4jwM0iJTOm
         EqI/rDcS1hyvuVeOMkraKHXDq2OgYyyt6YA2NRptvme+66bstWN+qfpvGGSYobx8ZP+S
         KJ0S5H1EwovJDcZAvxemU/Nz6iqre46BuspED+5cncZJTBSW8dcuw/Eal2s8dSfVqBOW
         ZYuBqgmuCGPP98gwG/ARINJbBsFj2lKo21E/GNhT9j5ZMIL5RKJr4jfaX6k6bz+LRu0S
         vkztmuWgP9gAickZ//HWTM60AjC5dQ6eY0nBdt3tJveOgN2PK8KG0FJ6N8Gbva5Xm37x
         rFcQ==
X-Gm-Message-State: ANhLgQ0O8RXYXD2H6l+kHFr2cHF7XdFKFI4FCWo++otLqDCdx/LZApiC
        fT8jFE0m/V0LIVstHxdPnjw6FB0x
X-Google-Smtp-Source: ADFU+vuIQ4nZQDr7h1+dRRhJor7WfF7qK2bRJ4jY3lBE5gQDrZ5BEwZ0KcJUHwCKjCX4pGh10YTv8A==
X-Received: by 2002:a17:906:14d6:: with SMTP id y22mr8175946ejc.289.1583425808272;
        Thu, 05 Mar 2020 08:30:08 -0800 (PST)
Received: from jwang-Latitude-5491.pb.local ([2001:1438:4010:2558:d8ec:cf8e:d7de:fb22])
        by smtp.gmail.com with ESMTPSA id h22sm293651edq.28.2020.03.05.08.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:30:07 -0800 (PST)
From:   Jack Wang <jinpuwang@gmail.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [stable-4.14 0/3] some backport for stable
Date:   Thu,  5 Mar 2020 17:30:04 +0100
Message-Id: <20200305163007.25659-1-jinpuwang@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha,

Please consider following backport for next stable release.

First patch for vhost_net has been tested with our in house regression tests
with VM migration with kernel 4.14.171, but should be also applied to older
stable tree.

mce patch is to fix a call trace in EPYC Rome server during boot.

EDAC one is to fix a regression backported to at least 4.14 and 4.19, should be
applied to both tree, kernel 5.4/5.5 already have the patch.

Regards,
Jack Wang from IONOS SE.

Eugenio Pérez (1):
  vhost: Check docket sk_family instead of call getname

Yazen Ghannam (2):
  x86/mce: Handle varying MCA bank counts
  EDAC/amd64: Set grain per DIMM

 arch/x86/kernel/cpu/mcheck/mce-inject.c | 14 +++++++-------
 arch/x86/kernel/cpu/mcheck/mce.c        | 22 +++++++---------------
 drivers/edac/amd64_edac.c               |  1 +
 drivers/vhost/net.c                     | 13 ++-----------
 4 files changed, 17 insertions(+), 33 deletions(-)

-- 
2.17.1

