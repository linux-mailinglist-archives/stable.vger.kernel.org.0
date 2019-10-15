Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7668CD80B5
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 22:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbfJOUKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 16:10:44 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33129 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfJOUKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 16:10:43 -0400
Received: by mail-io1-f66.google.com with SMTP id z19so49345736ior.0
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 13:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WIMp52CAKzHghF+2e/jNlYAAEKJd975b+6wt0t+FfVY=;
        b=ZFC+xb5C9+88Lpje8WEXOJoY+2xZ5x7gs2Pij4UgTRgFB9pF1VD1TecwCh7vttpvR7
         SnK98LgyU5vrvCaYONaPlvJMfvxSINVHZby4WleRgLPHQMAqUWK8WARFbxEKQriM8Flp
         mOyJeEyAzmAbHCOOG5mTCwRisXFvkeX1GHMWJGOUVbIC9hcBqrGa7XgShUZmlYUatnxf
         FUmJawI9dQyNGNCxH/VMvaiOYxJA5IpCpxEfG3J1W5ucSA7Hhn8UGFy7SXssVFAA8zGN
         EYvAYmZbhc36JofSH1bD9XAY17v3H1ewMpAAxK+TA/igOJ8BuyxxaoreH2qDzvmsFuoB
         8vjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WIMp52CAKzHghF+2e/jNlYAAEKJd975b+6wt0t+FfVY=;
        b=uWAiRWzTZENKg3W6waEWANQFiDzNSvdtEf0Mz3km32pLC+ARdxZOuXojsceqsrRI4o
         /z0aq9Rqs/ImtoL0qqciGPdmPOIKN+PC1zIUpu98aUjcLwXGFmuw+/GKlPC78tXG5MiD
         ruiHvlYtbAXMvkKlVr0leZzwPewPSHCB8AKmVT0tF00aM0V6ObuvI7lZ62/UcUPvs1+2
         nY30j1vzr1gQrqtDW1eNIrJ+T3R4HjNw9hw/c6o2+E/0e79DD/GvgWkVIPX/otbCUDfj
         NxEj3uhV2M6NPQvxfAStY1pB4LFCutjPYWB41iPa3r2n7dhk2OmZkV4GWiK774tLJ8Y3
         G8WA==
X-Gm-Message-State: APjAAAUqVacX3va8F4XNBXzi679rQcK9b/wl7KLNGXz/avnwhMZOgPED
        qHqZ4+OLIg+vDQBjECqS18XNF0cbJ/wUnA==
X-Google-Smtp-Source: APXvYqxyc9zmaZsTAJUWgjjppuQ8/fMYKs46wjhkI7m32W+hC0YsBf37Vpge1QmmaM60S8JXyJrYiw==
X-Received: by 2002:a02:c544:: with SMTP id g4mr25058717jaj.79.1571170241274;
        Tue, 15 Oct 2019 13:10:41 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m15sm3030459ilg.49.2019.10.15.13.10.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 13:10:40 -0700 (PDT)
Subject: Re: [PATCH] libata/ahci: Fix PCS quirk application
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Andreas Friedrich <afrie@gmx.net>,
        Stephen Douthit <stephend@silicom-usa.com>,
        stable@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <157116925749.1211205.12806062056189943042.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06a3c771-e6b6-10fb-fe8f-acaec2c3526f@kernel.dk>
Date:   Tue, 15 Oct 2019 14:10:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <157116925749.1211205.12806062056189943042.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/15/19 1:54 PM, Dan Williams wrote:
> Commit c312ef176399 "libata/ahci: Drop PCS quirk for Denverton and
> beyond" got the polarity wrong on the check for which board-ids should
> have the quirk applied. The board type board_ahci_pcs7 is defined at the
> end of the list such that "pcs7" boards can be special cased in the
> future if they need the quirk. All prior Intel board ids "<
> board_ahci_pcs7" should proceed with applying the quirk.

Thanks Dan (and others), applied.

-- 
Jens Axboe

