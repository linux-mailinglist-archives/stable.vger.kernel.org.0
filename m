Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518D7D0456
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfJHXpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:45:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:19713 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbfJHXpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:45:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 16:45:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="223399081"
Received: from jhogan1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.221])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2019 16:45:15 -0700
Date:   Wed, 9 Oct 2019 02:45:14 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 001/106] tpm: use tpm_try_get_ops() in tpm-sysfs.c.
Message-ID: <20191008234514.GB13437@linux.intel.com>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171125.167365005@linuxfoundation.org>
 <20191008125120.GF608@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008125120.GF608@amd>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 02:51:20PM +0200, Pavel Machek wrote:
> For example this did not have any locking, and is now protected by
> 
>         get_device(&chip->dev);
> 
>         down_read(&chip->ops_sem);
> 
> . Is that intended? Is this known to fix any bugs?

It is, sysfs code can otherwise race when ops is set NULL in
class shutdown.

/Jarkko
